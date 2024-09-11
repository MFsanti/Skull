extends Node

@export var mob_scene: PackedScene
var score

func Game_Over() -> void:
	# Detener los temporizadores
	$scorer_timer.stop()
	$mob_timer.stop()
	
	
	# Opcionalmente, detener el movimiento del jugador o cambiar la escena a "Game Over"
	$player.queue_free()  # Elimina al jugador de la escena, simulando que ha perdido
	print("¡Has perdido!")

func New_Game(): 
	score = 0 
	$player.start($start_position.position)
	$start_timer.start() 

func _ready() -> void:
	New_Game()

func _on_mob_timer_timeout() -> void:
	var mob = mob_scene.instantiate()
	
	var mob_spawn_location = $mob_path/spawn
	mob_spawn_location.progress_ratio = randf()
	
	var direction = mob_spawn_location.rotation + PI / 2
	mob.position = mob_spawn_location.position
	direction += randf_range(-PI / 4, PI / 4) 
	mob.rotation = direction
	
	# Asignar la velocidad al mob
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0).rotated(direction)
	mob.linear_velocity = velocity  # Asignar la velocidad para que el mob se mueva
	
	add_child(mob)  # Agregar el mob a la escena

func _on_scorer_timer_timeout() -> void:
	score+=1 

func _on_start_timer_timeout() -> void:
	$mob_timer.start()
	$scorer_timer.start()
	pass
