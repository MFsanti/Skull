extends StaticBody3D

var is_on = true
var usable = true

# Asigna la luz a esta variable desde el inspector
@onready var light = $"../../../../Iluminacion/Escaleras"# Cambia "Ruta/Al/OmniLight" a la ruta correcta


func action_use():
	if usable:
		if is_on:
			turn_off()
		else:
			turn_on()

func turn_off():
	is_on = false
	light.visible = false  
	print("Luz apagada")

func turn_on():
	is_on = true
	light.visible = true  
	print("Luz encendida")
