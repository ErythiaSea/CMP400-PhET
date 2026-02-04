@tool

extends Node3D
@export var length_scale: float = 1.0
@export var distance_from_center: float = 1.0

@onready var _vel_comp_x: ForceArrow = $VelocityCompX
@onready var _vel_comp_y: ForceArrow = $VelocityCompY
@onready var _vel_comp_t: ForceArrow = $VelocityCompT
@onready var _accel_comp_t: ForceArrow = $AccelCompT
@onready var arrows: Array[ForceArrow] = [_vel_comp_x, _vel_comp_y, _vel_comp_t, _accel_comp_t]
# @onready var _vel_total: MeshInstance3D = $VelocityTotal

# The parent should modify these with appropriate values
var vel: Vector3 = Vector3.UP
var accel: Vector3 = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !visible:
		scale = Vector3.ZERO
		return
	else:
		scale = Vector3.ONE
		
	var y_mul: float = 1.0
	
	var fwd = vel.normalized()
	var accel_dir = accel.normalized()
	var horizontal_vel: Vector2 = Vector2(vel.x, vel.z)
		
	if !Engine.is_editor_hint():
	## todo: i need to reduce duplicate code here this gets messy fast
		if (horizontal_vel.length_squared() > 0.05):
			_vel_comp_x.body_mesh.height = horizontal_vel.length()*length_scale
			_vel_comp_x.visible = true

			_vel_comp_x.rotation.y = atan2(-horizontal_vel.y, horizontal_vel.x)
		else:
			_vel_comp_x.visible = false
			
		if (abs(vel.y) > 0.05):
			_vel_comp_y.body_mesh.height = abs(vel.y)*length_scale
			_vel_comp_y.visible = true
			if vel.y > 0:
				_vel_comp_y.rotation.x = 0
			else:
				y_mul = -1.0
				_vel_comp_y.rotation_degrees.x = 180
		else:
			_vel_comp_y.visible = false
					
		if (vel.length_squared() > 0.05 and _vel_comp_x.visible and _vel_comp_y.visible):
			_vel_comp_t.body_mesh.height = vel.length()*length_scale
			_vel_comp_t.visible = true
			
			# construct basis from side and up vectors relative to forward direction
			var side: Vector3 = Vector3.UP.cross(fwd).normalized()
			var new_up: Vector3 = fwd.cross(side).normalized()
			var new_basis: Basis = Basis(side, new_up, fwd)
			# rotate basis by x -90 to account for arrow facing up and not forward
			new_basis = new_basis * Basis.from_euler(Vector3(TAU/4, 0, 0))
			_vel_comp_t.basis = new_basis
		else:
			_vel_comp_t.visible = false
			
		if (accel.length_squared() > 0.05):
			_accel_comp_t.body_mesh.height = accel.length()*length_scale
			_accel_comp_t.visible = true;
			
			var side: Vector3 = Vector3.UP.cross(accel_dir).normalized()
			if (side == Vector3.ZERO): # if accel_dir == Vector3.DOWN
				side = Vector3.FORWARD
			var new_up: Vector3 = accel_dir.cross(side).normalized()
			var new_basis: Basis = Basis(side, new_up, accel_dir)
			# rotate basis by x -90 to account for arrow facing up and not forward
			new_basis = new_basis * Basis.from_euler(Vector3(TAU/4, 0, 0))
			_accel_comp_t.basis = new_basis
		else:
			_accel_comp_t.visible = false
	
	_vel_comp_x.position = (distance_from_center + _vel_comp_x.body_mesh.height/2) * Vector3(horizontal_vel.x, 0, horizontal_vel.y).normalized()
	_vel_comp_y.position.y = (distance_from_center +_vel_comp_y.body_mesh.height/2) * y_mul
	_vel_comp_t.position = (distance_from_center + _vel_comp_t.body_mesh.height/2) * fwd
	_accel_comp_t.position = (distance_from_center + _accel_comp_t.body_mesh.height/2) * accel_dir
