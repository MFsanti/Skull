extends StaticBody3D

var isOpen = false
var usable = true

func _ready() -> void:
	pass # Replace with function body.

func action_use():
	if ! isOpen and usable: 
		open_door()
	elif isOpen and usable: 
		close_door()

func open_door(): 
	usable = false 
	$AnimationPlayer2.play("open")
	isOpen = true
 
func close_door(): 
	usable = false 
	$AnimationPlayer2.play("close")
	isOpen = false
