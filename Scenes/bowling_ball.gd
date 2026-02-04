extends RigidBody3D

@export var apply_air_resistance: bool = false
@export var air_resistance_coeff: float = 0.03

@onready var force_diag = $ArrowRoot

var fired: bool = false
var fire_impulse_strength: float = 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if fired:
		if Input.is_action_just_pressed("ball_fire"):
			_reset()
		return
	
	if Input.is_action_pressed("ball_left"):
		move_and_collide(Vector3.LEFT * 3 * delta)
	if Input.is_action_pressed("ball_right"):
		move_and_collide(Vector3.RIGHT * 3 * delta)
	if Input.is_action_pressed("ball_forward"):
		move_and_collide(Vector3.FORWARD * 3 * delta)
	if Input.is_action_pressed("ball_backward"):
		move_and_collide(Vector3.BACK * 3 * delta)
	if Input.is_action_pressed("ball_up"):
		move_and_collide(Vector3.UP * 3 * delta)
	if Input.is_action_pressed("ball_down"):
		move_and_collide(Vector3.DOWN * 3 * delta)
		
	if Input.is_action_just_pressed("ball_fire"):
		freeze = false
		linear_velocity = Vector3.ZERO
		angular_velocity = Vector3.ZERO
		apply_central_impulse(Vector3.FORWARD * 50)
		fired = true


func _reset() -> void:
	fired = false
	position = Vector3(0, 1, 0)
	freeze = true
