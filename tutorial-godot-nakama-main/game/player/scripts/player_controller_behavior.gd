extends Behavior
class_name PlayerControllerBehavior

@export var max_acceleration: float = 100.0
@export var max_turn: float = PI/6

func steer(agent: CharacterBody3D) -> Vector3:
	
	var turn : float = Input.get_axis("ui_right", "ui_left")
	var gas : float = Input.get_axis("ui_down","ui_up")
	
	var acc := Vector3.ZERO
	acc += -agent.basis.z * gas * max_acceleration # Forward
	
	acc = acc.rotated(agent.basis.y, turn * max_turn * sign(agent.velocity.dot(-agent.basis.z)))
	
	return acc.limit_length(max_acceleration)
