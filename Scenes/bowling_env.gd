extends Node3D

@onready var _gizmo: Gizmo3D = $Gizmo3D
@onready var _bowling_ball: RigidBody3D = $ForceBall
@onready var _ghost_ball: MeshInstance3D = $GhostBall
@onready var _traj_line: TrajectoryLine = $TrajectoryLine

@onready var _lane_wood: StaticBody3D = $laneWood
@onready var _lane_cloth: StaticBody3D = $laneCloth
@onready var _lane_rubber: StaticBody3D = $laneRubber
@onready var _barrier_root: Node3D = $barrierRoot
@onready var _barrier: StaticBody3D = $barrierRoot/barrier0
@onready var _top_barrier: StaticBody3D = $barrierRoot/barrier1

@onready var _gui_root: SceneGui = $GUIRoot

const _center_cam_pos: Vector3 = Vector3(-6.5, 4, -7.5)

var pin_pos: Dictionary[RigidBody3D, Vector3]
var fired: bool = false
var can_fire: bool = true

var checking = false
signal check_done

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.new_question_type.connect(_on_new_q_type)
	
	_barrier.hide()
	_barrier.process_mode = Node.PROCESS_MODE_DISABLED
	_top_barrier.hide()
	_top_barrier.process_mode = Node.PROCESS_MODE_DISABLED
		
	_gizmo.select(_bowling_ball)
	if (GameManager.current_gamemode != GameManager.mode.freeplay):
		can_fire = false
		_lane_cloth.hide();
		_lane_cloth.process_mode = Node.PROCESS_MODE_DISABLED
		_lane_rubber.hide();
		_lane_rubber.process_mode = Node.PROCESS_MODE_DISABLED
		$Camera3D.position = _center_cam_pos
		GameManager.generate_q_type()
		
	if (GameManager.current_gamemode == GameManager.mode.proj_mtn):
		_barrier.show()
		_barrier.process_mode = Node.PROCESS_MODE_INHERIT
		_gizmo.mode -= _gizmo.ToolMode.MOVE
		
		var con = false;
		for pin in $Pins.get_children() as Array[RigidBody3D]:
			if (!con):
				con = true
				continue
			pin.queue_free()
			
	if (GameManager.current_gamemode == GameManager.mode.e_coeff):
		_gizmo.hide()
		_construct_drop_setup()
		$Pins.queue_free()
			
	for pin in $Pins.get_children() as Array[RigidBody3D]:
		pin_pos[pin] = pin.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ball_fire") and can_fire:
		fired = !fired
		if fired:
			_bowling_ball.fire()
			_gizmo.deselect(_bowling_ball)
			_traj_line.toggle_aim(false)
			_traj_line.show()
			_toggle_pin_rot(true)
		else:
			reset_scene(false)
			
func _physics_process(delta: float) -> void:
	if (checking):
		if (GameManager.current_gamemode == GameManager.mode.e_coeff):
			if _bowling_ball.linear_velocity.y < 0.01 and _bowling_ball.bounces > 0:
				_bowling_ball.freeze = true
				_end_checking()

func reset_scene(full: bool = false) -> void:
	if (full): 
		_bowling_ball.full_reset()
		fired = false
	else: _bowling_ball.reset()
	_gizmo.select(_bowling_ball)
	_traj_line.toggle_aim(true)
	_toggle_pin_rot(false)
	_reset_pins()

func _reset_pins():
	for pin in $Pins.get_children() as Array[RigidBody3D]:
		pin.position = pin_pos[pin]
		pin.linear_velocity = Vector3.ZERO
		pin.angular_velocity = Vector3.ZERO
		pin.rotation = Vector3.ZERO

func _construct_lob_setup() -> void:
	var dist = randf_range(0.4, 2.0)
	var barrier_height = 1 + randf_range(0, 4)
	var angle = 0
	var vel = 0
	var air_time = 0
	_barrier_root.position.y = barrier_height - 2.5
	_bowling_ball.position.z = _barrier.position.z + dist
	_bowling_ball.position.y = 0
	$Pins.get_child(0).position.z = _barrier.position.z - dist
	_traj_line.hide()
	
	if (GameManager.current_q_type != GameManager.q_type.suvat_lob_powerangle):
		var req_y_vel = sqrt(2 * 9.8 * barrier_height + 0.3) #0.3 for some leeway
		air_time = 2 * (req_y_vel/9.8)
		var req_x_vel = dist/air_time
		vel = sqrt(pow(req_y_vel, 2) + pow(req_x_vel, 2))
		angle = atan2(req_y_vel, req_x_vel)
		angle = rad_to_deg(angle)
		
		_bowling_ball.fire_impulse_strength = vel
		_bowling_ball.rotation_degrees.y = angle
	
	GameManager.q_args = {
		"wall_height": barrier_height,
		"wall_dist": dist,
		"pin_dist": dist*2,
		"angle": angle,
		"vel": vel,
		"air_time": air_time
	}
	
	_top_barrier.hide()
	_top_barrier.process_mode = Node.PROCESS_MODE_DISABLED
	_gui_root.format_question(GameManager.q_args)
	
func _construct_needle_setup() -> void:
	_construct_lob_setup()
	_top_barrier.show()
	_top_barrier.process_mode = Node.PROCESS_MODE_INHERIT
	
func _construct_drop_setup() -> void:
	var init_height = randf_range(1.0, 8.0)
	var e_coeff = randf_range(0.01,1)
	var final_height = init_height * e_coeff * e_coeff
	
	GameManager.q_args = {
		"init": init_height,
		"final": final_height,
		"e": e_coeff
	}
	
	_lane_wood.physics_material_override.bounce = 0.5
	_bowling_ball.position.y = 0.2
	_ghost_ball.position.y = 0.2
	_ghost_ball.position.z = -7.5
	_bowling_ball.position.z = -7.5
	_bowling_ball.fire_impulse_strength = 0
	
	if (GameManager.current_q_type != GameManager.q_type.e_findcoeff):
		_lane_wood.physics_material_override.bounce = e_coeff
	if (GameManager.current_q_type != GameManager.q_type.e_initheight):
		_bowling_ball.position.y = init_height
	if (GameManager.current_q_type != GameManager.q_type.e_finalheight):
		_ghost_ball.position.y = final_height
	
	_traj_line.hide()
	_ghost_ball.show()
	_gui_root.format_question(GameManager.q_args)
	_gizmo.clear_selection()
	
func _construct_collision_setup() -> void:
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

func _on_skip_button_pressed() -> void:
	checking = false
	GameManager.generate_q_type()
		
func _on_new_q_type(type: GameManager.q_type) -> void:
	_bowling_ball.reset()
	if (GameManager.current_gamemode == GameManager.mode.e_coeff):
		_construct_drop_setup()
	if (GameManager.current_gamemode == GameManager.mode.collision):
		_construct_collision_setup()
	if (GameManager.current_gamemode == GameManager.mode.proj_mtn):
		if (type < GameManager.q_type.suvat_needle_maxheight):
			_construct_lob_setup()
		else:
			_construct_needle_setup()

func _on_param_1_value_changed(value: float) -> void:
	match GameManager.current_q_type:
		GameManager.q_type.e_initheight:
			_bowling_ball.position.y = value
		GameManager.q_type.e_finalheight:
			_ghost_ball.position.y = value
		GameManager.q_type.e_findcoeff:
			_lane_wood.physics_material_override.bounce = max(value, 0)

func _on_param_2_value_changed(value: float) -> void:
	pass # Replace with function body.

func _on_check_button_pressed() -> void:
	_bowling_ball.fire()
	checking = true

func _end_checking() -> void:
	check_done.emit()
	
func _toggle_pin_rot(on: bool) -> void:
	for pin in $Pins.get_children() as Array[RigidBody3D]:
		pin.axis_lock_angular_x = on
		pin.axis_lock_angular_y = on
		pin.axis_lock_angular_z = on
