extends Node3D

@onready var _gizmo: Gizmo3D = $Gizmo3D
@onready var _bowling_ball: RigidBody3D = $ForceBall
@onready var _traj_line: TrajectoryLine = $TrajectoryLine

@onready var _lane_wood: StaticBody3D = $laneWood
@onready var _lane_cloth: StaticBody3D = $laneCloth
@onready var _lane_rubber: StaticBody3D = $laneRubber
@onready var _barrier: StaticBody3D = $barrier

var pin_pos: Dictionary[RigidBody3D, Vector3]
var fired: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_barrier.hide()
	_barrier.process_mode = Node.PROCESS_MODE_DISABLED
		
	_gizmo.select(_bowling_ball)
	if (GameManager.current_gamemode != GameManager.freeplay and GameManager.current_gamemode != GameManager.e_coeff):
		_lane_cloth.hide();
		_lane_cloth.process_mode = Node.PROCESS_MODE_DISABLED
		_lane_rubber.hide();
		_lane_rubber.process_mode = Node.PROCESS_MODE_DISABLED
	if (GameManager.current_gamemode == GameManager.proj_mtn):
		_barrier.show()
		_barrier.process_mode = Node.PROCESS_MODE_INHERIT
		_gizmo.mode -= _gizmo.ToolMode.MOVE
		
		var con = false;
		for pin in $Pins.get_children() as Array[RigidBody3D]:
			if (!con):
				con = true
				continue
			pin.queue_free()
			
	for pin in $Pins.get_children() as Array[RigidBody3D]:
		pin_pos[pin] = pin.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ball_fire"):
		fired = !fired
		if fired:
			_bowling_ball.fire()
			_gizmo.deselect(_bowling_ball)
			_traj_line.toggle_aim(false)
			_traj_line.show()
		else:
			reset_scene(false)

func reset_scene(full: bool = false) -> void:
	if (full): 
		_bowling_ball.full_reset()
		fired = false
	else: _bowling_ball.reset()
	_gizmo.select(_bowling_ball)
	_traj_line.toggle_aim(true)
	for pin in $Pins.get_children() as Array[RigidBody3D]:
		pin.position = pin_pos[pin]
		pin.linear_velocity = Vector3.ZERO
		pin.angular_velocity = Vector3.ZERO
		pin.rotation = Vector3.ZERO
		
func _construct_lob_setup() -> void:
	var dist = randf_range(0.4, 2.0)
	var barrier_y_scale = randf_range(0.3, 1.5)
	
	_barrier.scale.y = barrier_y_scale
	_bowling_ball.position.z = _barrier.position.z + dist
	_bowling_ball.position.y = 0.2
	$Pins.get_child(0).position.z = _barrier.position.z - dist
	_traj_line.hide()

func _on_reset_button_pressed() -> void:
	reset_scene(true)

func _on_pin_mass_slider_value_changed(value: float) -> void:
	for pin in $Pins.get_children() as Array[RigidBody3D]:
		pin.mass = value

func _on_wood_e_slider_value_changed(value: float) -> void:
	_lane_wood.physics_material_override.bounce = value

func _on_play_button_pressed() -> void:
	if (GameManager.current_gamemode == GameManager.proj_mtn):
		_construct_lob_setup()
	else:
		push_warning("no function for this button in this mode yet!")
