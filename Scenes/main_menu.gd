extends Control
@export_file(".tscn") var bowling_scene
@export_file(".tscn") var siege_scene
@export_file(".tscn") var pool_scene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Version.text = ProjectSettings.get_setting("application/config/version", "v0.2")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_pressed() -> void:
	$MainButtons.hide()
	$SceneSelect.show()
	pass # Replace with function body.


func _on_bowling_pressed() -> void:
	if (!bowling_scene): return
	get_tree().change_scene_to_file(bowling_scene)


func _on_siege_pressed() -> void:
	if (!siege_scene): return
	get_tree().change_scene_to_file(siege_scene)


func _on_pool_pressed() -> void:
	if (!pool_scene): return
	get_tree().change_scene_to_file(pool_scene)


func _on_back_pressed() -> void:
	$MainButtons.show()
	$SceneSelect.hide()
