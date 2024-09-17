extends CharacterBody3D

@export var bounce_impulse = 16
@export var speed: float = 10
@export var fall_acceleration = 75
@export var jump_impulse = 20

var target_velocity = Vector3.ZERO
var input_vector = Vector3.ZERO

signal hit

func _ready() -> void:
	# Aquí puedes realizar inicializaciones si es necesario
	pass

func _physics_process(delta: float) -> void:
	# Manejar entrada y movimiento
	input_vector = Vector3.ZERO
	
	if Input.is_action_pressed("ui_right"):
		input_vector.x += 1
	if Input.is_action_pressed("ui_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("ui_up"):
		input_vector.z -= 1
	if Input.is_action_pressed("ui_down"):
		input_vector.z += 1

	input_vector = input_vector.normalized()
	target_velocity = input_vector * speed

	# Movimiento y gravedad
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jump_impulse
	else:
		velocity.y -= fall_acceleration * delta

	velocity.x = target_velocity.x
	velocity.z = target_velocity.z

	move_and_slide()

	# Manejo de colisiones
	for index in range(get_slide_collision_count()):
		var collision = get_slide_collision(index)
		var collider = collision.get_collider()
		if collider and collider.is_in_group("mob"):
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				var mob = collider
				mob.squash()
				velocity.y = bounce_impulse
				break  # Solo manejar la primera colisión

func die():
	hit.emit()
	queue_free()

# Asegúrate de conectar esta función a la señal de detección del área o colisiones
func _on_mobdetector_body_entered(body: Node3D) -> void:
	if body.is_in_group("mob"):
		die()
