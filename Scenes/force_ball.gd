extends RigidBody3D

@onready var force_diag = $ArrowRoot

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if Input.is_action_pressed("ball_left"):
		state.apply_force(Vector3.LEFT * 5)
	if Input.is_action_pressed("ball_right"):
		state.apply_force(Vector3.RIGHT * 5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		linear_velocity.y = 10.0
	
	force_diag.vel = linear_velocity
