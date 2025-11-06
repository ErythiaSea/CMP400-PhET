@tool

class_name ForceArrow
extends MeshInstance3D

@onready var head: MeshInstance3D = $ArrowHead
@onready var head_mesh: CylinderMesh = $ArrowHead.mesh as CylinderMesh
@onready var body_mesh: CylinderMesh = mesh as CylinderMesh

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	head.position.y = body_mesh.height/2 + head_mesh.height/2
