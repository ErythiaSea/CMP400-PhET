extends Node

const MAIN_MENU_SCENE = "res://Scenes/main_menu.tscn"

enum {
	freeplay,
	e_coeff,
	proj_mtn,
	collision
}

var current_gamemode: int = freeplay

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
