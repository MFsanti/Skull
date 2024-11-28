extends CharacterBody3D

@export var SPEED: float = 5.0
@export var GRAVITY: float = 9.8

@onready var _camera: Camera3D = %main_camera  # Asegúrate de que la cámara esté correctamente conectada.

# Variables de movimiento

# Posición fija de la cámara (ajusta estos valores según la posición que desees)
var camera_offset: Vector3 = Vector3(0, 5, -10)  # La cámara estará detrás y arriba del jugador

func _ready() -> void:
	# Asegúrate de que la cámara esté en la posición correcta al inicio
	_camera.global_transform.origin = global_transform.origin + camera_offset

func _physics_process(delta: float) -> void:
	# Aplicar gravedad si no estamos en el suelo
	if not is_on_floor():
		velocity.y -= GRAVITY * delta
	else:
		velocity.y = 0  # Reiniciar la componente Y al tocar el suelo

	# Obtener la dirección de entrada del jugador
	var input_dir: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if input_dir != Vector2.ZERO:
		# Transformar la dirección de entrada en relación a la cámara
		var forward: Vector3 = -_camera.global_transform.basis.z
		var right: Vector3 = _camera.global_transform.basis.x
		var direction: Vector3 = (forward * input_dir.y + right * input_dir.x).normalized()
		
		# Mover al jugador en esa dirección
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		# Detener el movimiento si no hay entrada
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	# Mover al jugador
	move_and_slide()

	# Asegurar que la cámara siempre esté mirando al jugador
	_camera.look_at(global_transform.origin, Vector3.UP)
