extends Node
class_name Behaviors

@export var max_speed : float = 100.0 # m/s

@onready var _agent: CharacterBody3D = get_parent()
@onready var _behaviors := find_children("*","Behavior")

func _ready() -> void:
	print(_behaviors)
	_agent.velocity = Vector3.ZERO

func _physics_process(delta: float) -> void:
	for b: Behavior in _behaviors:
		_agent.velocity += b.steer(_agent) * delta
	
	_agent.velocity = _agent.velocity.limit_length(max_speed)
	
	if _agent.velocity.length_squared() > 0:
		_agent.look_at(_agent.position + _agent.velocity * sign(_agent.velocity.dot(-_agent.basis.z)))
	
	_agent.move_and_slide()
