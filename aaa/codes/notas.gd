extends StaticBody3D

@onready var ui_notas = $Control

func _ready() -> void:
	ui_notas.hide()

func action_use():
		ui_notas.show()
		Global.leida = true
		#if Input.is_action_pressed("cancel"):
			#ui_notas.hide()
func _process(delta: float) -> void:
	if ui_notas.visible and Input.is_action_just_pressed("cancel"):
		ui_notas.hide()
