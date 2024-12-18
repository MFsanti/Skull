extends StaticBody3D
var isOpen = false
var usable = true

func _ready() -> void:
	pass # Replace with function body.

func action_use():
	if ! isOpen and usable: 
		open_()
	elif isOpen and usable: 
		close_()

func open_(): 
	usable = false 
	$AnimationPlayer.play("open")
	isOpen = true
 
func close_(): 
	usable = false 
	$AnimationPlayer.play("close")
	isOpen = false

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	usable = true
