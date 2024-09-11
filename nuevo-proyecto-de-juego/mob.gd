extends RigidBody2D

func _ready():
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])
	# Conectar la señal "body_entered" usando Callable con "C" mayúscula
 # Conectar la señal "body_entered" usando Callable
	self.connect("body_entered", Callable(self, "_on_body_entered"))
func _on_body_entered(body):
	print("Body entered:", body.name)  # Verifica qué cuerpo está entrando en contacto
	if body.is_in_group("player"):
		print("Player detected!")
		body.Game_Over()
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
