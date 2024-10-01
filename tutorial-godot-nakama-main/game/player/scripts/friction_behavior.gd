extends Behavior
class_name FrictionBehavior

@export_range(0,1) var instensity: float = 0.3

func steer(_agent: CharacterBody3D) -> Vector3:
	if instensity == 0: return Vector3.ZERO
	return _agent.velocity * (-1 / instensity)
