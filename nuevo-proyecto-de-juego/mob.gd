extends Area2D

@export var velocity: Vector2 = Vector2.ZERO

func _ready():
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])
	# self.body_entered.connect(_on_body_entered)
	

func _process(delta: float) -> void:
	position += velocity * delta

func _on_body_entered(body):
	print("toco el body:", body.name) 
	if body.is_in_group("player"):
		print("toco al player")
		body.Game_Over()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
