extends Node3D

@onready var _gizmo: Gizmo3D = $Gizmo3D
@onready var _bowling_ball: RigidBody3D = $ForceBall

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_gizmo.select(_bowling_ball)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
