extends RigidBody3D
class_name BowlingBall

@export var apply_air_resistance: bool = false
@export var air_resistance_coeff: float = 0.03

@onready var force_diag = $ArrowRoot
@export var traj_line: Node3D

var fire_impulse_strength: float = 10
var bounces: int = 0
var pins_hit: int = 0
var barrier_hit: bool = false
var bounce_timer: float = 0
const BOUNCE_WAIT: float = 0.03
var time_flying: float = 0
var flight_time_history: Array[float]
var max_height: float = 0
var max_height_history: Array[float]
var in_air: bool = false

var init_pos := Vector3(0, 1, 0)
var last_pos := init_pos
var init_rot: Vector3 = Vector3.ZERO
var last_rot := init_rot

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func fire(use_velocity: bool = true) -> void:
	last_pos = position
	last_rot = rotation
	freeze = false
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO
	if (use_velocity):
		set_velocity(fire_impulse_strength)
	else:
		apply_central_impulse(-transform.basis.z * fire_impulse_strength)
	force_diag.show()
	force_diag.scale = Vector3(0.25, 0.25, 0.25)

func reset() -> void:
	force_diag.hide()
	freeze = true
	bounce_timer = BOUNCE_WAIT
	bounces = 0
	pins_hit = 0
	barrier_hit = false
	print(max_height_history)
	print(flight_time_history)
	max_height_history.clear()
	flight_time_history.clear()
	time_flying = 0
	max_height = 0
	
	# i cannot understand why this is necessary but it is
	if (GameManager.current_gamemode == GameManager.mode.freeplay):
		(func(): position = last_pos).call_deferred()
		(func(): rotation = last_rot).call_deferred()
	
func full_reset() -> void:
	last_pos = init_pos
	last_rot = init_rot
	reset()

func set_velocity(total: float) -> void:
	linear_velocity = (total * -transform.basis.z)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !freeze:
		force_diag.accel = get_gravity()/mass
		force_diag.vel = linear_velocity
		bounce_timer -= delta
		time_flying += delta
		if (position.y > max_height):
			max_height = position.y
		in_air = (position.y > 0.00)
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
		
	traj_line.expected_init_vel = fire_impulse_strength / mass


func _on_body_entered(body: Node) -> void:
	if (body is StaticBody3D):
		print("body entered")
		if (body.name.contains("barrier")):
			barrier_hit = true
			print("hit barrier!")
			bounces += 1
			bounce_timer = BOUNCE_WAIT
		if (bounce_timer < 0):
			bounces += 1
			print(bounces)
			bounce_timer = BOUNCE_WAIT
			print(time_flying)
			flight_time_history.append(time_flying)
			max_height_history.append(max_height)
			max_height = 0
			time_flying = 0
			
	elif (body is RigidBody3D):
		pins_hit += 1
