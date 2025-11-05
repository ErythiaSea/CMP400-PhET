@tool

extends Node3D
@export var length_scale: float = 1.0
@export var distance_from_center: float = 10.0

@onready var _vel_comp_x: MeshInstance3D = $VelocityCompX
@onready var _vel_comp_y: MeshInstance3D = $VelocityCompY
@onready var arrows: Array[MeshInstance3D] = [_vel_comp_x, _vel_comp_y]
# @onready var _vel_total: MeshInstance3D = $VelocityTotal

@onready var _vel_x_cyl = _vel_comp_x.mesh as CylinderMesh
@onready var _vel_y_cyl = _vel_comp_y.mesh as CylinderMesh
# @onready var _vel_tot_cyl = _vel_total.mesh as CylinderMesh

var vel_x: float = 1.0
var vel_y: float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !Engine.is_editor_hint():
		_vel_x_cyl.height = abs(vel_x)*length_scale
		_vel_y_cyl.height = abs(vel_y)*length_scale
	
	var y_mul: float = 1.0
	if vel_y > 0:
		print("notflip")
		_vel_comp_y.rotation.x = 0
	else:
		print ("flip")
		y_mul = -1.0
		_vel_comp_y.rotation_degrees.x = 180
	
	_vel_comp_x.position.x = (distance_from_center + _vel_x_cyl.height/2) * (1 if vel_x > 0 else -1)
	_vel_comp_y.position.y = (distance_from_center + _vel_y_cyl.height/2) * y_mul
	pass
