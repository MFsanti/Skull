extends CharacterBody2D

@export var speed : float

var axis : Vector2

func get_axis() -> Vector2:  
	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("left"))
	axis.y = int(Input.is_action_pressed("up")) - int(Input.is_action_pressed("down"))
	return axis.normalized()
	
	
func _process(delta):
	motion_ctrl() 

func motion_ctrl() -> void: 
	velocity.x = get_axis().x * speed
	velocity.y = get_axis().y * -speed
	move_and_slide()
	
