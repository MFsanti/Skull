extends CharacterBody3D

const SPEED = 2
const JUMP_VELOCITY = 4.5
const sensitivity = 0.005
@onready var head = $Head
@onready var camera = $Head/Camera3D

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

func _process(delta: float) -> void:
	if Input.is_action_pressed("right"):
		position += head.transform.basis.x*delta*SPEED
	if Input.is_action_pressed("left"):
		position += head.transform.basis.x*delta*-SPEED
	if Input.is_action_pressed("forward"):
		position += head.transform.basis.z *delta*-SPEED
	if Input.is_action_pressed("back"):
		position += head.transform.basis.z *delta*SPEED
	move_and_slide()

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion: 
		head.rotate_y(-event.relative.x * sensitivity)
		camera.rotate_x(-event.relative.y * sensitivity)
