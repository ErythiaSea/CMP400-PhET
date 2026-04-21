## Used for validating answer input in the GUI

class_name FloatBox
extends LineEdit

signal value_changed(value: float)
var old_text := ""

func _ready() -> void:
	old_text = text
	text_changed.connect(_check_float)

func _check_float(new: String) -> void:
	if new.is_empty() or new.is_valid_float():
		old_text = new
		value_changed.emit(new as float)
	else:
		text = old_text
