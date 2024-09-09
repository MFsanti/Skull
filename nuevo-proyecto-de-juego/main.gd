extends Node

@export var mob_scene: PackedScene
var score

func Game_Over() -> void:
	$scorer_timer.stop()
	$mob_timer.stop()

func New_Game(): 
	score = 0 
	$player.start($start_position)
	$startTimer.start() 


func _on_mob_timer_timeout() -> void:
	var mob = mob_scene.instantiate()

	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	var direction = mob_spawn_location.rotation + PI / 2
	mob.position = mob_spawn_location.position
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	add_child(mob)


func _on_scorer_timer_timeout() -> void:
	score+=1 

func _on_start_timer_timeout() -> void:
	$mob_timer.start()
	$scorer_timer.start()
	pass
