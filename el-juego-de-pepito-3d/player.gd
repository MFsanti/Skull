extends CharacterBody3D

@export var bounce_impulse = 16 

@export var speed : float = 10 

@export var fall_acceleration = 75

var target_velocity = Vector3.ZERO

@export var jump_impulse = 20

var input_vector = Vector3.ZERO

#func _physics_process(delta: float) -> void: 
	#if not is_on_floor():
	#	velocity += get_gravity() * delta

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_right"):
		position += Vector3.RIGHT*delta*speed
	if Input.is_action_pressed("ui_left"):
		position += Vector3.LEFT*delta*speed
	if Input.is_action_pressed("ui_up"):
		position += Vector3.FORWARD*delta*speed
	if Input.is_action_pressed("ui_down"):
		position += Vector3.BACK*delta*speed

	target_velocity = input_vector * speed



	# Asegúrate de que el personaje esté en el suelo para saltar
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jump_impulse

	# Aplicar la gravedad
	if not is_on_floor():
		velocity.y -= fall_acceleration * delta

	# Actualizar la velocidad y el movimiento
		velocity.x = target_velocity.x
		velocity.z = target_velocity.z

	move_and_slide()
