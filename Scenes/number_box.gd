extends LineEdit

var old_text := ""

func _ready() -> void:
	old_text = text
	text_changed.connect(_check_int)

func _check_int(text: String) -> void:
	if text.is_empty() or text.is_valid_int():
		old_text = text
	else:
		text = old_text
