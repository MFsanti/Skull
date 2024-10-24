extends CharacterBody3D

const WALK_SPEED = 1
const RUN_SPEED = 2
const JUMP_VELOCITY = 3  # Ajusta esta constante
const GRAVITY = -9.8  # Gravedad más realista
const SLOW_DOWN = 0.5  # Velocidad de descenso
const SENSITIVITY = 0.005

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var raycast = $Head/Camera3D/RayCast3D

@onready var hint_icon = %ActionHintIcon

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		# Aplica la gravedad
		velocity.y += GRAVITY * delta
	else:
		# Reinicia la velocidad en Y al tocar el suelo
		velocity.y = 0

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

func _process(delta: float) -> void:
	
	process_raycast_cool()
	
	var speed = WALK_SPEED
	if Input.is_action_pressed("correr"):
		speed = RUN_SPEED

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
	
	

func process_raycast_cool():
	hint_icon.hide()
	if raycast.is_colliding(): 
		var collider = raycast.get_collider()
		print("Colisiona con: ", collider.name)  # Para verificar con qué colisiona
		if collider.has_method("action_use"):
			if Input.is_action_just_pressed("usar"):
				collider.action_use()
			else:
				hint_icon.show()
				print("MOstrar icono de accion")
		else:
			print("El objeto no tiene el método action_use")
	else:
		print("No colisiona con nada")

func process_raycast():
	if raycast.is_colliding(): 
		var collider = raycast.get_collider()
		print("Colisiona con: ", collider.name)  # Para verificar con qué colisiona
		if collider.has_method("action_use"):
			collider.action_use()
		else:
			print("El objeto no tiene el método action_use")
	else:
		print("No colisiona con nada")


func _input(event):
	if event is InputEventMouseMotion: 
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY) 
	
	#if event.is_action_pressed("usar"):
		#process_raycast() 
		#print("process_raycast")

	
