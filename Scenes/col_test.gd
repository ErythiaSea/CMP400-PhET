## Code for an invisible recreation of the bowling environment that exists
## below the main one in the collision scenario only.
## Used to test for resulting collision values before displaying these values in questions

extends Node3D

@onready var ball: RigidBody3D = $ForceBall
@onready var ball_pos: Vector3 = ball.position
@onready var pin: RigidBody3D = $BowlingPin
@onready var pin_pos: Vector3 = pin.position
signal collision_complete(result: Dictionary)

var ball_vels: Array[float] = [0]
var pin_vels: Array[float] = [0]
var tic_timer: int = 0
const TIC_WAIT: int = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pin.body_entered.connect(_pin_entered)
	pass # Replace with function body.

func simulate_collision(ball_mass: float, pin_mass: float, ball_vel: float) -> void:
	ball.mass = ball_mass
	pin.mass = pin_mass
	ball.position = ball_pos
	pin.position = pin_pos
	ball.rotation = Vector3.ZERO
	pin.rotation = Vector3.ZERO
	ball.linear_velocity = Vector3.ZERO
	pin.linear_velocity = Vector3.ZERO
	pin.angular_velocity = Vector3.ZERO
	ball_vels.clear()
	ball_vels.append(0)
	pin_vels.clear()
	pin_vels.append(0)
	tic_timer = 0
	(func(): ball.linear_velocity.z = -ball_vel).call_deferred()

func _pin_entered(body: Node) -> void:
	if (body != ball): return
	tic_timer = TIC_WAIT
	#var res: Dictionary = {}
	#print("hi")
	#res["ball_vel"] = ball.linear_velocity.length()
	#res["pin_vel"] = pin.linear_velocity.length()
	#collision_complete.emit(res)
	#print("i did it")
	#print(ball_vels)
	#print(pin_vels)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if (tic_timer > 0):
		tic_timer -= 1
		if (tic_timer == 0):
			var res: Dictionary = {}
			res["ball_vel"] = ball.linear_velocity.length()
			res["pin_vel"] = pin.linear_velocity.length()
			collision_complete.emit(res)
			print("signal emit")
	#if (ball_vels[ball_vels.size() - 1] != ball.linear_velocity.length()):
		#ball_vels.append(ball.linear_velocity.length())
	#if (pin_vels[pin_vels.size() - 1] != pin.linear_velocity.length()):
		#pin_vels.append(pin.linear_velocity.length())
