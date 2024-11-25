extends CharacterBody3D

const WALK_SPEED = 0.7
const GRAVITY = -9.8
const SENSITIVITY = 0.003

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var raycast = $Head/Camera3D/RayCast3D
@onready var hint_icon = %ActionHintIcon
@onready var point = %point
@onready var linterna = $Head/Camera3D/SpotLight3D



var dragged_item = null
var cursor_offset = Vector3(0, 1, 0)
var agarrado: RigidBody3D

func _physics_process(delta: float) -> void:

	if Input.is_action_pressed("encender"):
		linterna.visible = true 
	else:
		linterna.visible = false

	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		velocity.y = 0
	move_and_slide()

func _process(delta: float) -> void:
	process_raycast_cool()
	# Movimiento del jugador
	var speed = WALK_SPEED
	if Input.is_action_pressed("right"):
		position += head.transform.basis.x * delta * speed
	if Input.is_action_pressed("left"):
		position += head.transform.basis.x * delta * -speed
	if Input.is_action_pressed("forward"):
		position += head.transform.basis.z * delta * -speed
	if Input.is_action_pressed("back"):
		position += head.transform.basis.z * delta * speed

	move_and_slide()

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
# Funcion de interactuar con objetos y agarrarlos
func process_raycast_cool():
	hint_icon.hide()
	if raycast.is_colliding(): 
		var collider = raycast.get_collider()
		if collider.has_method("action_use"):
			if Input.is_action_just_pressed("usar"):
				collider.action_use()  
			else:
				hint_icon.show()
		if agarrado == null and collider.is_in_group("agarrables"):
			if Input.is_action_just_pressed("agarrar"):
				agarrar_objeto(collider)
		if agarrado != null and Input.is_action_just_released("agarrar"):
			soltar_objeto()
				
				
func agarrar_objeto(objeto):
	agarrado = objeto
	agarrado.freeze = true
	
	agarrado.reparent(point)
	agarrado.position = Vector3.ZERO
func soltar_objeto():
	agarrado.reparent(get_parent())
	agarrado.freeze = false
	agarrado = null

#func encender_linterna():
	#if Input.is_action_pressed("encender"):
		#linterna.visible = false
	#else: 
		#linterna.visible = true

func _input(event):
	if event is InputEventMouseMotion: 
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
