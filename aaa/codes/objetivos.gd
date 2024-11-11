extends Node

@onready var comida = $"../RigidBody3D"

@onready var micro = $"../microondas/Area3D"

# Referencia al nodo de UI
var ui_layer: CanvasLayer
var objetivo_label: Label
var panel_container: PanelContainer

# Lista de objetivos en orden
var objetivos = [
	"Dirígete a tu casa",
	"Busca a tu Familia",
	"Prepara la comida",
	"xd"
	# Añade más objetivos aquí
]

var objetivo_actual = 0

func _ready():
	# Crear CanvasLayer para asegurar que la UI esté siempre visible
	ui_layer = CanvasLayer.new()
	add_child(ui_layer)
	
	# Crear un PanelContainer para el fondo
	panel_container = PanelContainer.new()
	ui_layer.add_child(panel_container)
	
	# Configurar el panel
	panel_container.set_position(Vector2(20, 20))
	panel_container.add_theme_stylebox_override("panel", StyleBoxFlat.new())
	var style = panel_container.get_theme_stylebox("panel")
	style.bg_color = Color(0, 0, 0, 0.5)  # Fondo semi-transparente
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	
	# Crear MarginContainer para el padding
	var margin_container = MarginContainer.new()
	panel_container.add_child(margin_container)
	margin_container.add_theme_constant_override("margin_left", 10)
	margin_container.add_theme_constant_override("margin_right", 10)
	margin_container.add_theme_constant_override("margin_top", 10)
	margin_container.add_theme_constant_override("margin_bottom", 10)
	
	# Crear VBoxContainer para organizar elementos verticalmente
	var vbox = VBoxContainer.new()
	margin_container.add_child(vbox)
	
	# Crear el título "Objetivo Actual"
	var titulo_label = Label.new()
	vbox.add_child(titulo_label)
	titulo_label.text = "OBJETIVO ACTUAL"
	titulo_label.add_theme_font_size_override("font_size", 16)
	titulo_label.add_theme_color_override("font_color", Color(1, 0.8, 0.2))  # Color amarillo
	
	# Crear el Label para el objetivo actual
	objetivo_label = Label.new()
	vbox.add_child(objetivo_label)
	objetivo_label.add_theme_font_size_override("font_size", 20)
	objetivo_label.add_theme_color_override("font_color", Color(1, 1, 1))
	objetivo_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	objetivo_label.custom_minimum_size = Vector2(300, 0)  # Ancho mínimo para el texto
	
	# Mostrar el primer objetivo
	actualizar_objetivo()

func actualizar_objetivo():
	if objetivo_actual < objetivos.size():
		objetivo_label.text = objetivos[objetivo_actual]

func siguiente_objetivo():
	if objetivo_actual < objetivos.size() - 1:
		objetivo_actual += 1
		# Añadir una pequeña animación al cambiar de objetivo
		crear_efecto_cambio_objetivo()
		actualizar_objetivo()

func crear_efecto_cambio_objetivo():
	# Crear una animación simple de fade
	var tween = create_tween()
	tween.tween_property(objetivo_label, "modulate", Color(1, 1, 1, 0), 0.3)
	tween.tween_callback(actualizar_objetivo)
	tween.tween_property(objetivo_label, "modulate", Color(1, 1, 1, 1), 0.3)

# Función para verificar la completación de objetivos
func verificar_objetivo():
	match objetivo_actual:
		0:  # Llegar a casa
			if esta_en_casa():
				siguiente_objetivo()
		1:  # Buscar Nota
			if vio_la_nota_():
				siguiente_objetivo()
		3:  # Hacer comida
			if prepararcomida():
				siguiente_objetivo()
		4: 
			pass
		# Añade más casos según necesites

# Funciones de ejemplo para verificar condiciones en 3D
func esta_en_casa() -> bool:
	var player = ($"../Node3D")
	var casa_area = ($"../casa/Area3D")
	return casa_area.overlaps_body(player)
	return false
	
func vio_la_nota_():
	if Global.leida:
		return true

func prepararcomida():
	
	pass
func _process(_delta):
	verificar_objetivo()
