extends Control
@export_file(".tscn") var bowling_scene

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


func _open_bowling() -> void:
	if (!bowling_scene): return
	get_tree().change_scene_to_file(bowling_scene)

func _on_back_pressed() -> void:
	$MainButtons.show()
	$SceneSelect.hide()


func _on_projmot_pressed() -> void:
	GameManager.current_gamemode = GameManager.proj_mtn
	_open_bowling()

func _on_cor_pressed() -> void:
	GameManager.current_gamemode = GameManager.e_coeff
	_open_bowling()


func _on_collision_pressed() -> void:
	GameManager.current_gamemode = GameManager.collision
	_open_bowling()
