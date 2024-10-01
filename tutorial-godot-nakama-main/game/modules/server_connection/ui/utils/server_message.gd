## Label conectado automáticamente a las señales de ServerConnection
extends Label

@export var show_success := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ServerConnection.error.connect(_on_error)
	ServerConnection.success.connect(_on_success)

func _on_error(_code: int, msg: String) -> void:
	text = msg
	show()

func _on_success(msg: String) -> void:
	text = msg if show_success else ""
