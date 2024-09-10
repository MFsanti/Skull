extends CharacterBody2D

signal hit

@export var speed : float

@onready var sprite = $AnimatedSprite2D

var axis : Vector2

func start(start_position: Vector2) -> void:
	position = start_position
	print("Jugador iniciado en la posición: ", start_position)


func _process(delta):
	motion_ctrl() 

func get_axis() -> Vector2:  
	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("left"))
	axis.y = int(Input.is_action_pressed("up")) - int(Input.is_action_pressed("down"))
	return axis.normalized()
	
func motion_ctrl() -> void: 
	velocity.x = get_axis().x * speed
	velocity.y = get_axis().y * -speed
	move_and_slide()

	if velocity.length() > 0:
		sprite.play()
	else:
		sprite.stop()

	if velocity.x != 0:
		sprite.animation = "walk"
		sprite.flip_v = false
		sprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		sprite.animation = "up"
		sprite.flip_v = velocity.y > 0
