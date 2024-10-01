extends Node
## Singleton que se encarga de centralizar todas las operaciones contra el
## servidor.

## Señal emitida por administrador de conexion para indicar una operacion exitosa
signal success(msg: String)
## Señal emitida por administrador de conexion para indicar un posible error
signal error(code: int, msg: String)

const COLLECTION_GAMES := "games"
const COLLECTION_SEQUENCES := "%s_sequences" # Incluye codigo del juego

## Conexión al servidor
var _client : NakamaClient
var _session: NakamaSession
var _socket: NakamaSocket = null

func _ready() -> void:
	var config := _load_config()
	_client = Nakama.create_client(
		config.key, config.url, config.port, config.scheme
		)

## Carga los datos de conexion por defecto
# TODO: Poder establecer los datos con un archivo de configuracion propio
func _load_config(path: String = "res://modules/server_connection/default_config.cfg") -> ServerConnectionConfig:
	var config_file = ConfigFile.new()
	var err = config_file.load(path)
	
	# TODO: Agregar validaciones del archivo
	
	if err != OK: return

	var config := ServerConnectionConfig.new()
	config.key = config_file.get_value("server","key")
	config.url = config_file.get_value("server","url")
	config.port = config_file.get_value("server","port")
	config.scheme = config_file.get_value("server","scheme")

	print_debug("Configuración de server cargada: ", path)

	return config


# Operaciones necesarias para la secuencia de juego

## Registrar un nuevo usuario
## 
## Se conecta creando un nuevo usuario que no existe
func register_async(user: String, email: String, password: String, display_name: String) -> int:
	
	if email == "": return _error_message(ERR_INVALID_DATA, "Debe ingresar un email")
	
	if display_name == "": return _error_message(ERR_INVALID_DATA, "Debe ingresar un Nombre")
	
	if await check_user_exists_async(user, password) == OK:
		return _error_message(ERR_ALREADY_EXISTS, "Usuario ya registrado")
	
	var new_session: NakamaSession = await _client.authenticate_email_async(
		email, password, user, true
		)
	
	if new_session.is_exception(): return _error(new_session.get_exception())
	
	_session = new_session
	_client.update_account_async(_session, user, display_name)
	
	return _success("Usuario creado con éxito")

## Check user
##
## Verifica si la cuenta a registrar ya existe sin emitir señales
func check_user_exists_async(user: String, password: String) -> int:
	var new_session: NakamaSession = await _client.authenticate_email_async(
		"", password, user, false
		)
	
	if new_session.is_exception(): return new_session.get_exception().status_code
	
	await _client.session_logout_async(new_session)
	
	return OK

## Login
##
## Se conecta con un usuario ya existente
func login_async(user: String, password: String) -> int:
	var new_session: NakamaSession = await _client.authenticate_email_async(
		"", password, user, false )
	
	if new_session.is_exception(): return _error(new_session.get_exception())
	
	_session = new_session
	return _success("Conectado con éxito")

## Logout
##
## Cierra la sesión abierta
func logout_async() -> int:
	var result: NakamaAsyncResult = await _client.session_logout_async(_session)
	
	if result.is_exception(): return _error(result.get_exception())
	
	return _success("Desconectado con éxito")

## Refresca la session
##
## Previene que el usuario deba reloggearse frecuentemente
func refresh_session_async() -> int:
	# Verifica si la session expiró o está por expirar
	if not _session.is_expired(): return OK
	
	# Intenta resfrescar la session
	_session = await _client.session_refresh_async(_session)
	
	# Al no lograrlo, el usuario debe ingresar sus credenciales nuevamente
	if _session.is_exception(): return _error(_session.get_exception())
		
	return OK



## Dar de alta un nuevo juego
##
## Crea un nuevo juego con toda su metadata, esto incluye cuales son los datos de los niveles
## metadata en formato JSON
func game_create_async(_key: String, _display_name: String, _metadata: String) -> int:
	return _error_message(ERR_CANT_CREATE, "Funcionalidad aun no implemetada")

## Crear una secuencia PUBLICA para un juego
func sequence_create_async(data: Dictionary) -> int:
	return await write_data_async(
		COLLECTION_SEQUENCES % data.juego, 
		data.nombre.to_snake_case(),
		JSON.stringify(data))

## Crear una secuencia PROPIA para un juego y un usuario (o grupo de usuarios)

## Iniciar una sesión de juego
## Unirse a una sesión de juego
## Obtener los PARAMETROS de una sesión de juego
## Obtener los RESULTADOS de una sesión de juego
## Finalizar una sesión de juego

## Crear un grupo
## Unirse a un grupo creado por alguien más


# Funciones de soporte a las operaciones

## Dada una session, emite una señal y devuelve el respectivo código de error.
func _error(exception: NakamaException) -> int:
	error.emit(exception.status_code, exception.message)
	return exception.status_code

## Dado un código y un mensaje, emite una señal y devuelve el respectivo código de error.
func _error_message(code: int, msg: String = "Ocurrió un error") -> int:
	error.emit(code, msg)
	return code

## Dado un mensaje retorna con éxito la operacion y emite la respectiva señal
func _success(msg: String) -> int:
	success.emit(msg)
	return OK

## Storage

func write_data_async(collection: String, key: String, json_data: String, can_read: int = 1, can_write: int = 1) -> int:
	
	var acks : NakamaAPI.ApiStorageObjectAcks = await _client.write_storage_objects_async(
		_session,[
			NakamaWriteStorageObject.new(collection, key, can_read, can_write, json_data,""),
		])
	
	if acks.is_exception(): return _error(acks.get_exception())
	
	return _success("Dato almacenado con éxito")

func read_data() -> Dictionary:
	# var read_object_id = NakamaStorageObjectId.new("juegos", null, _session.user_id)
	#var result : NakamaAPI.ApiStorageObjects = await _client.read_storage_objects_async(_session, [read_object_id])
	return {}

func get_games_async() -> Dictionary:
	var result : NakamaAPI.ApiStorageObjectList = await _client.list_storage_objects_async(
		_session, COLLECTION_GAMES
		)

	var rs := {}
	for o in result.objects:
		var j = JSON.parse_string(o.value)
		rs[o.key] = j

	return rs

func get_game_sequences_async(game_code: String) -> Array:
	var result : NakamaAPI.ApiStorageObjectList = await _client.list_storage_objects_async(
		_session, (COLLECTION_SEQUENCES % game_code), _session.user_id
		)
		
	var rs := []
	#print("Data del juego %s recuperado: %s" % [game_code,result])
	for o in result.objects:
		rs.append(JSON.parse_string(o.value))
	#print("RS: %s" % rs)
	return rs


## Matches

func create_match(match_name: String = "") -> int:
	_socket = Nakama.create_socket_from(_client)
	
	var connected : NakamaAsyncResult = await _socket.connect_async(_session)
	
	if connected.is_exception():
		error.emit(connected.get_exception().status_code, connected.get_exception().message)
		return connected.get_exception().status_code
	
	var matchs : NakamaRTAPI.Match = await _socket.create_match_async(match_name)
	
	success.emit("Creada partida %s (%s)" % [matchs.match_id, matchs.label])
	return OK

func list_matches() -> void:
	var min_players := 1
	var max_players := 10
	var limit := 10
	var authoritative := false
	var label := ""
	var query := ""
	var result: NakamaAsyncResult = await _client.list_matches_async(_session, min_players, max_players, limit, authoritative, label, query)

	for m: Dictionary in result.matches:
		print(m)
		print("%s: %s/10 players" % [m.match_id, m.size])


## Groups
func split_user(group_name: String) -> String:
	return group_name.erase(0, _session.username.length() + 1)
	




func create_group_async(group_name: String, description: String) -> int:
	var result : NakamaAsyncResult = await _client.create_group_async(
		_session, 
		_session.username + "_" + group_name, description)
	return result_code(result)

func delete_group_async(group_id: String) -> int:
	var result : NakamaAsyncResult = await _client.delete_group_async(_session, group_id)
	return result_code(result)

func list_user_groups_async() -> Array:
	var result : NakamaAsyncResult = await _client.list_user_groups_async(_session, _session.user_id)
	return result.user_groups.map(func(g:Dictionary) -> String: return g.group)
	
func result_code(result: NakamaAsyncResult) -> int:
	return result.get_exception().status_code if result.is_exception() else OK
