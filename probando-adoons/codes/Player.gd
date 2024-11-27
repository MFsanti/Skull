extends MeshInstance3D

@export var speed : float = 10 

func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_right"):
		position += Vector3.RIGHT*delta*speed
	if Input.is_action_pressed("ui_left"):
		position += Vector3.LEFT*delta*speed
	if Input.is_action_pressed("ui_up"):
		position += Vector3.FORWARD*delta*speed
	if Input.is_action_pressed("ui_down"):
		position += Vector3.BACK*delta*speed
