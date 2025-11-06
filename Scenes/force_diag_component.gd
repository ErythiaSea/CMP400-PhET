extends Node3D
@export var length_scale: float = 1.0
@export var distance_from_center: float = 10.0

@onready var _vel_comp_x: ForceArrow = $VelocityCompX
@onready var _vel_comp_y: ForceArrow = $VelocityCompY
@onready var arrows: Array[ForceArrow] = [_vel_comp_x, _vel_comp_y]
# @onready var _vel_total: MeshInstance3D = $VelocityTotal

var vel_x: float = 1.0
var vel_y: float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var y_mul: float = 1.0
		
	## todo: i need to reduce duplicate code here this gets messy fast
	if (abs(vel_x) > 0):
		_vel_comp_x.body_mesh.height = abs(vel_x)*length_scale
		_vel_comp_x.visible = true
	else:
		_vel_comp_x.body_mesh.height = abs(vel_x)*length_scale
		_vel_comp_x.visible = false
	if (abs(vel_y) > 0):
		_vel_comp_y.body_mesh.height = abs(vel_y)*length_scale
		_vel_comp_y.visible = true
	else:
		_vel_comp_y.visible = false

	if vel_y > 0:
		_vel_comp_y.rotation.x = 0
	else:
		y_mul = -1.0
		_vel_comp_y.rotation_degrees.x = 180
	
	_vel_comp_x.position.x = (distance_from_center + _vel_comp_x.body_mesh.height/2) * (1 if vel_x > 0 else -1)
	_vel_comp_y.position.y = (distance_from_center +_vel_comp_y.body_mesh.height/2) * y_mul
