extends Node3D

@onready var _gizmo: Gizmo3D = $Gizmo3D
@onready var _bowling_ball: RigidBody3D = $ForceBall
@onready var _traj_line: TrajectoryLine = $TrajectoryLine

var pin_pos: Dictionary[RigidBody3D, Vector3]
var fired: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_gizmo.select(_bowling_ball)
	for pin in $Pins.get_children() as Array[RigidBody3D]:
		pin_pos[pin] = pin.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ball_fire"):
		fired = !fired
		_traj_line.toggle_aim(!fired)
		if fired:
			_bowling_ball.fire()
			_gizmo.deselect(_bowling_ball)
		else:
			_bowling_ball.reset()
			_gizmo.select(_bowling_ball)
			for pin in $Pins.get_children() as Array[RigidBody3D]:
				pin.position = pin_pos[pin]
				pin.linear_velocity = Vector3.ZERO
				pin.angular_velocity = Vector3.ZERO
				pin.rotation = Vector3.ZERO
