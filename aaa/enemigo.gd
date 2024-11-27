extends CharacterBody3D

@export var max_speed : float = .5

@export var max_velocity : float = .2

@onready var player = $"../Node3D"
func _ready() -> void:
	pass 

func _process(delta: float) -> void:
	var move : Vector3 = player.position - position 
	move = move.normalized()*max_speed
	velocity += move * delta
	var friccion = velocity * -0.9
	velocity += friccion * delta
	velocity.limit_length(max_velocity)
	position += velocity * delta 
