extends Camera3D
var mlook: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Input.is_action_pressed("camera_fwd")):
		position += basis * Vector3.FORWARD * delta * 5
	if (Input.is_action_pressed("camera_bck")):
		position -= basis * Vector3.FORWARD * delta * 5
	if (Input.is_action_pressed("camera_left")):
		position += basis * Vector3.LEFT * delta * 5
	if (Input.is_action_pressed("camera_right")):
		position -= basis * Vector3.LEFT * delta * 5
	if (Input.is_action_pressed("camera_up")):
		position += Vector3(0, 1, 0) * delta * 5
	if (Input.is_action_pressed("camera_down")):
		position -= Vector3(0, 1, 0) * delta * 5

func _input(event):
	if event is InputEventMouseMotion and mlook:
		rotation_degrees.y -= (event.relative.x * 0.2)
		rotation_degrees.x -= (event.relative.y * 0.2)
		rotation_degrees.x = clamp(rotation_degrees.x, -80, 90)
		
	if event is InputEventKey:
		if event.is_action_pressed("cursor_toggle"):
			mlook = !mlook
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if mlook else Input.MOUSE_MODE_VISIBLE
		

	if event is InputEventMouseButton:
		if event.is_action_pressed("mouselook_hold"):
			mlook = true
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if mlook else Input.MOUSE_MODE_VISIBLE
			
		elif event.is_action_released("mouselook_hold"):
			mlook = false
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if mlook else Input.MOUSE_MODE_VISIBLE
