extends Node

@export var mob_scene: PackedScene
var Score = 0

func Game_Over(body) -> void:
	GLOBAL.HighScore = max(Score, GLOBAL.HighScore)
	
	print("toco el body:", body.name) 
	if body.is_in_group("player"):
		$scorer_timer.stop()
		$mob_timer.stop()
		$player.queue_free()  
		print("¡Has perdido!")
		$HUD.show_game_over()

func New_Game(): 
	$HUD.update_score(Score)
	$HUD.show_message("Preparado?")
	Score = 0 
	$player.start($start_position.position)
	$start_timer.start()
	#$player.connect("hit", Callable(self, "Game_Over"))

func _ready() -> void:
	pass

func _on_mob_timer_timeout() -> void:
	var mob = mob_scene.instantiate()
	
	var mob_spawn_location = $mob_path/spawn
	mob_spawn_location.progress_ratio = randf()
	
	var direction = mob_spawn_location.rotation + PI / 2
	mob.position = mob_spawn_location.position
	direction += randf_range(-PI / 4, PI / 4) 
	mob.rotation = direction
	
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0).rotated(direction)
	mob.velocity = velocity 
	
	#mob.body_entered.connect(mob._on_body_entered($player))
	mob.body_entered.connect(Game_Over)
	
	add_child(mob)  
	
	
func _on_scorer_timer_timeout() -> void:
	Score+=1 
	$HUD.update_score(Score)

func _on_start_timer_timeout() -> void:
	$mob_timer.start()
	$scorer_timer.start()
