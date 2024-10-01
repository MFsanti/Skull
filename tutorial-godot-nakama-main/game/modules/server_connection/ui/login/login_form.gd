extends Node

signal login_successful

# Visibility groups
@onready var login_buttons := %LoginButtons
@onready var register_buttons := %RegisterButtons
@onready var register_inputs := %RegisterInputs

# Inputs
@onready var user := %UserInput
@onready var display_name := %NameInput
@onready var email := %EmailInput
@onready var password := %PasswordInput

# Message
@onready var message_label : Control = %ServerMessage

var _buttons : Array

func _ready() -> void:
	ServerConnection.error.connect(func(_c: int,_m: String) -> void: enable_buttons())
	ServerConnection.success.connect(func(_m: String) -> void: enable_buttons())
	
	_buttons = find_children("*Button", "Button")

func hide_message() -> void:
	message_label.text = ""

func disable_buttons() -> void:
	_buttons.map(func(b: Button) -> void: b.disabled = true)

func enable_buttons() -> void:
	_buttons.map(func(b: Button) -> void: b.disabled = false)

## Muestra los elementos del form de login
func show_login_form() -> void:
	# Register
	register_inputs.hide()
	register_buttons.hide()
	# Login
	login_buttons.show()

## Muestra los elementos del form de registro
func show_register_form() -> void:
	# Register
	register_inputs.show()
	register_buttons.show()
	# Login
	login_buttons.hide()

## Operaciones
func register_new_user() -> int:
	return await ServerConnection.register_async(
		user.text, email.text, password.text, display_name.text
		)

func login_user() -> void:
	var result : int = await ServerConnection.login_async(user.text, password.text)
	
	if result == OK: login_successful.emit()

## Acciones de botones
func _on_register_button_pressed() -> void:
	hide_message()
	show_register_form()

func _on_login_button_pressed() -> void:
	disable_buttons()
	hide_message()
	login_user()

func _on_confirmar_pressed() -> void:
	disable_buttons()
	hide_message()
	if (await register_new_user()) == OK:
		show_login_form()

func _on_cancelar_register() -> void:
	hide_message()
	show_login_form()
