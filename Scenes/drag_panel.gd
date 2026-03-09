extends PanelContainer

var is_being_held: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if event.pressed:
				is_being_held = true
				print("true")
			else:
				is_being_held = false
				print("false")
	
	if not is_being_held: return
	if event is InputEventMouseMotion:
		position += event.screen_relative

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
