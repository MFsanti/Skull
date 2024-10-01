extends Behavior
class_name GravityBehavior

@export var force: Vector3 = Vector3.DOWN * 9.8

func steer(_agent: CharacterBody3D) -> Vector3:
	if _agent.is_on_floor(): return Vector3.ZERO
	return force
