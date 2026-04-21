## Note for CMP400 markers: I (Eryth Davidson, 2201593) did NOT make this code.
## It was acquired from the Godot Asset Library and authored by Chris Charbonneau.
## You can find the source here: https://github.com/chrisizeful/Gizmo3D

@tool
class_name GizmoLoader
extends EditorPlugin
## <summary>
## Plugin that add/removes the <see cref="Gizmo3D"/> node.
## </summary>

func _enter_tree() -> void:
	add_custom_type("Gizmo3D", "Node3D", ResourceLoader.load("res://addons/Gizmo3DScript/gizmo_loader.gd"), null)

func _exit_tree() -> void:
	remove_custom_type("Gizmo3D")
