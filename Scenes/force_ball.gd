extends RigidBody3D

@export var apply_air_resistance: bool = false
@export var air_resistance_coeff: float = 0.03
@export var push_strength: float = 7.5

@onready var force_diag = $ArrowRoot

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if Input.is_action_pressed("ball_left"):
		state.apply_force(Vector3.LEFT * push_strength)
	if Input.is_action_pressed("ball_right"):
		state.apply_force(Vector3.RIGHT * push_strength)
		
	if (apply_air_resistance):
		# force = -C * v^2
		state.apply_force(-air_resistance_coeff * abs(state.linear_velocity) * state.linear_velocity)
		print("applying air resistance of ", air_resistance_coeff)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		linear_velocity.y = 10.0
	
	force_diag.vel = linear_velocity
