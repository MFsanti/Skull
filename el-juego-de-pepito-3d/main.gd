extends Node

@export var mob_scene: PackedScene
@export var mob_spawn: Node3D  
@export var player: Node3D 

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _on_mob_timer_timeout() -> void:
	if mob_scene == null:
		return

	var mob = mob_scene.instantiate()

	var player_position = player.position
	var mob_spawn_position = mob_spawn.position

	if mob.has_method("initialize"):
		mob.initialize(mob_spawn_position, player_position)

	add_child(mob)

	var mob_spawn_location = get_node("spawn/mob_spawn")
	if mob_spawn_location:
		mob_spawn_location.progress_ratio = randf()

func _on_player_hit() -> void:
	$mob_timer.stop()  
