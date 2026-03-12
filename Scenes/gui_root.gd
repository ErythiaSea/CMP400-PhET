extends CanvasLayer

@export var air_resistance_toggle: CheckButton
@export var air_resistance_slider_container: HBoxContainer
@export var air_resistance_coefficient_slider: HSlider
@export var air_resistance_coefficient_label: Label
@export var mass_slider: HSlider
@export var mass_label: Label
@export var push_strength_slider: HSlider
@export var push_strength_label: Label
@export var time_scale_slider: HSlider
@export var time_scale_label: Label
@export var pin_mass_slider: HSlider
@export var pin_mass_label: Label
@export var wood_e_label: Label
@export var ball_angle_label: Label
@export var ball_bounces_label: Label
@export var ball_vel_label: Label
@export var force_ball: RigidBody3D

@export var ctrl_panel: PanelContainer
@export var ball_panel: PanelContainer
@export var world_panel: PanelContainer
@export var equation_panel: PanelContainer
var panel_init_pos: Array[Vector2]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	air_resistance_toggle.toggled.connect(_on_artoggle_toggled)
	air_resistance_coefficient_slider.value_changed.connect(_on_arcslider_value_changed)
	if (mass_slider):
		mass_slider.value_changed.connect(_on_mass_slider_value_changed)
	push_strength_slider.value_changed.connect(_on_ps_slider_value_changed)
	
	panel_init_pos.append(ctrl_panel.position)
	panel_init_pos.append(ball_panel.position)
	panel_init_pos.append(world_panel.position)
	panel_init_pos.append(equation_panel.position)
	pass # Replace with function body.

# holy hardcoding batman!
func _on_arcslider_value_changed(value: float) -> void:
	force_ball.air_resistance_coeff = value
	air_resistance_coefficient_label.text = "Air Resistance Coefficient: %.2f" % value
	
func _on_artoggle_toggled(toggled_on: bool) -> void:
	force_ball.apply_air_resistance = toggled_on
	air_resistance_slider_container.visible = toggled_on
	
func _on_mass_slider_value_changed(value: float) -> void:
	force_ball.mass = value
	mass_label.text = "Mass: %.2fkg" % value
	
func _on_ps_slider_value_changed(value: float) -> void:
	force_ball.fire_impulse_strength = value
	push_strength_label.text = "Throw Impulse: %.2fN/s" % value
	
func _on_time_scale_slider_value_changed(value: float) -> void:
	Engine.time_scale = value
	time_scale_label.text = "Simulation Speed: %d" % (int)(value*100)
	time_scale_label.text += "%"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (force_ball.freeze):
		ball_angle_label.text = "Angle: %.2f°" % force_ball.rotation_degrees.x
	else:
		ball_bounces_label.text = "Bounces: %d" % force_ball.bounces
		var vel = force_ball.linear_velocity
		if (abs(vel.y) < 0.001):
			vel.y = 0.0
		ball_vel_label.text = "X: %.3fm/s\nY: %.3fm/s\nZ: %.3fm/s" % [abs(vel.x), vel.y, abs(vel.z)]

func _on_ball_button_pressed() -> void:
	ball_panel.visible = !ball_panel.visible

func _on_info_button_pressed() -> void:
	ctrl_panel.visible = !ctrl_panel.visible
	
func _on_world_button_pressed() -> void:
	world_panel.visible = !world_panel.visible

func _on_equation_button_pressed() -> void:
	equation_panel.visible = !equation_panel.visible

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file(GameManager.MAIN_MENU_SCENE)

func _on_reset_windows_button_pressed() -> void:
	ctrl_panel.position = panel_init_pos[0]
	ball_panel.position = panel_init_pos[1]
	world_panel.position = panel_init_pos[2]
	equation_panel.position = panel_init_pos[3]

func _on_pin_mass_slider_value_changed(value: float) -> void:
	pin_mass_label.text = "Pin Mass: %.2fkg" % value

func _on_wood_e_slider_value_changed(value: float) -> void:
	wood_e_label.text = "Wood Lane e: %.2f" % value
