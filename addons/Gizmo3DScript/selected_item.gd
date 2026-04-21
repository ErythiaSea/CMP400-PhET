## Note for CMP400 markers: I (Eryth Davidson, 2201593) did NOT make this code.
## It was acquired from the Godot Asset Library and authored by Chris Charbonneau.
## You can find the source here: https://github.com/chrisizeful/Gizmo3D

## Represents a single selected node.
class_name SelectedItem
extends Object

var target_original : Transform3D
var target_global : Transform3D

var sbox_instance : RID
var sbox_instance_offset : RID
var sbox_xray_instance : RID
var sbox_xray_instance_offset : RID
