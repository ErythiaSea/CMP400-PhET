extends CanvasLayer

@export var air_resistance_toggle: CheckButton
@export var air_resistance_slider_container: HBoxContainer
@export var air_resistance_coefficient_slider: HSlider
@export var air_resistance_coefficient_label: Label
@export var mass_slider: HSlider
@export var mass_label: Label
@export var push_strength_slider: HSlider
@export var push_strength_label: Label
@export var force_ball: RigidBody3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	air_resistance_toggle.toggled.connect(_on_artoggle_toggled)
	air_resistance_coefficient_slider.value_changed.connect(_on_arcslider_value_changed)
	mass_slider.value_changed.connect(_on_mass_slider_value_changed)
	push_strength_slider.value_changed.connect(_on_ps_slider_value_changed)
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
	mass_label.text = "Ball Mass: %.2f" % value
	
func _on_ps_slider_value_changed(value: float) -> void:
	force_ball.push_strength = value
	push_strength_label.text = "Push Strength: %.2f" % value

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
