extends RigidBody3D

@onready var force_diag = $ArrowRoot

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		linear_velocity.y = 10.0
	
	force_diag.vel_x = linear_velocity.x
	force_diag.vel_y = linear_velocity.y
	pass
