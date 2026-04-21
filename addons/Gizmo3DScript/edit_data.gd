## Note for CMP400 markers: I (Eryth Davidson, 2201593) did NOT make this code.
## It was acquired from the Godot Asset Library and authored by Chris Charbonneau.
## You can find the source here: https://github.com/chrisizeful/Gizmo3D

## Temporary data holder for interacting with the gizmo.
class_name EditData
extends Object

var show_rotation_line : bool
var original : Transform3D
var mode : Gizmo3D.TransformMode
var plane : Gizmo3D.TransformPlane
var click_ray : Vector3
var click_ray_pos : Vector3
var center : Vector3
var mouse_pos : Vector2

## Rotation arc
var rotation_axis : Vector3
var accumulated_rotation_angle : float
var display_rotation_angle : float
var initial_click_vector : Vector3
var previous_rotation_vector : Vector3
var gizmo_initiated : bool
