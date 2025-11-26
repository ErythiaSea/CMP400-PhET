extends RigidBody3D

@export var apply_air_resistance: bool = false
@export var air_resistance_coeff: float = 0.03
@export var push_strength: float = 7.5

@onready var force_diag = $ArrowRoot

var _force_array: Array[Vector3] = []
var _last_vel: Vector3 = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	#custom_integrator = true
	#state.apply_force(get_gravity())
	var push_vector: Vector3 = Vector3.ZERO
	
	if Input.is_action_pressed("ball_left"):
		push_vector += (Vector3.LEFT * push_strength)
	if Input.is_action_pressed("ball_right"):
		push_vector += (Vector3.RIGHT * push_strength)
	if Input.is_action_pressed("ball_forward"):
		push_vector += (Vector3.FORWARD * push_strength)
	if Input.is_action_pressed("ball_backward"):
		push_vector += (Vector3.BACK * push_strength)
		
	if (push_vector != Vector3.ZERO):
		state.apply_force(push_vector)
		_force_array.push_back(push_vector)
		
	if (apply_air_resistance):
		# force = -C * v^2
		var air_resistance: Vector3 = (-air_resistance_coeff * abs(state.linear_velocity) * state.linear_velocity)
		state.apply_force(air_resistance)
		_force_array.push_back(air_resistance)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var total_accel: Vector3 = get_gravity()
	for force in _force_array:
		total_accel += force/mass
		
	force_diag.accel = total_accel
	_force_array.clear()
	
	_last_vel = linear_velocity
	
	# jump
	if Input.is_action_just_pressed("ui_accept"):
		linear_velocity.y = 10.0
	   
	force_diag.vel = linear_velocity
	print("vel y is: ", linear_velocity.y)
