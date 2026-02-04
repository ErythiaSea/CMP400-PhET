extends MeshInstance3D

@export var projectile: Node3D

var show_aim = false
var base_line_thickness := 0.03

var expected_init_vel: float

const SHADER = preload("res://Scenes/trajectory_shader.gdshader")

func _ready() -> void:
	setup_line_material()

func _physics_process(_delta: float) -> void:
	# My projectile spawns based on the camera's position, making this a necessary reference
	if show_aim:
		draw_aim()

func toggle_aim(is_aiming):
	show_aim = is_aiming
	
	# Clear the mesh so it's no longer visible
	if not is_aiming:
		mesh = null

func get_front_direction() -> Vector3:
	return -projectile.get_global_transform().basis.z

func draw_aim():
	var start_pos = projectile.global_position
	
	var initial_velocity = get_front_direction() * expected_init_vel
	var result = get_trajectory_points(start_pos, initial_velocity)
	
	var points: Array = result.points
	var length: float = result.length
	
	if points.size() >= 2:
		var line_mesh = build_trajectory_mesh(points)
		mesh = line_mesh
	
	if material_override is ShaderMaterial:
		material_override.set_shader_parameter("line_length", length)
	else:
		mesh = null

func get_trajectory_points(start_pos: Vector3, initial_velocity: Vector3) -> Dictionary:
	var t_step := 0.01 # Sets the distance between each line point based on time
	var g: float = -ProjectSettings.get_setting("physics/3d/default_gravity", 9.8)
	var drag: float = ProjectSettings.get_setting("physics/3d/default_linear_damp", 0.0)
	var points := [start_pos]
	var total_length := 0.0
	var current_pos = start_pos
	var vel = initial_velocity
	
	for i in range(220):
		var next_pos = current_pos + vel * t_step
		vel.y += g * t_step
		vel *= clampf(1.0 - drag * t_step, 0, 1.0)
		
		if not raycast_query(current_pos, next_pos).is_empty():
			break
		
		total_length += (next_pos - current_pos).length()
		points.append(next_pos)
		current_pos = next_pos
	
	return {
	"points": points,
	"length": total_length
	}

func build_trajectory_mesh(points: Array) -> ImmediateMesh:
	var line_mesh := ImmediateMesh.new()
	if points.size() < 2:
		return line_mesh
	
	line_mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLES)
	
	var thickness := base_line_thickness
	var first = true
	var last_left: Vector3
	var last_right: Vector3
	var last_dist := 0.0
	var added_vertices := false
	var distance_along := 0.0
	
	for i in range(1, points.size()):
		var prev_pos = points[i - 1]
		var current_pos = points[i]
		var segment_length = prev_pos.distance_to(current_pos)
		var segment_dir = (current_pos - prev_pos).normalized()
		
		# Use a stable "up" vector from the camera
		var cam_up = get_parent().global_transform.basis.y
		var cam_right = get_parent().global_transform.basis.x
		# Project the mesh width direction using a constant up ref
		var right = segment_dir.cross(cam_up)
		# Fallback if nearly vertical
		if right.length_squared() < 0.0001:
			right = cam_right
		right = right.normalized() * thickness
		
		var new_left = current_pos - right
		var new_right = current_pos + right
		var curr_dist = distance_along + segment_length
		
		if not first:
			# First triangle
			line_mesh.surface_set_uv(Vector2(last_dist, 0.0))
			line_mesh.surface_add_vertex(last_left)
			
			line_mesh.surface_set_uv(Vector2(last_dist, 1.0))
			line_mesh.surface_add_vertex(last_right)
			
			line_mesh.surface_set_uv(Vector2(curr_dist, 1.0))
			line_mesh.surface_add_vertex(new_right)
			
			# Second triangle
			line_mesh.surface_set_uv(Vector2(last_dist, 0.0))
			line_mesh.surface_add_vertex(last_left)
			
			line_mesh.surface_set_uv(Vector2(curr_dist, 1.0))
			line_mesh.surface_add_vertex(new_right)
			
			line_mesh.surface_set_uv(Vector2(curr_dist, 0.0))
			line_mesh.surface_add_vertex(new_left)
			
			added_vertices = true
		else:
			# With no last_left or last_right points, the first point is skipped
			first = false
		
		last_left = new_left
		last_right = new_right
		last_dist = curr_dist
		distance_along = curr_dist
	
	if added_vertices:
		line_mesh.surface_end()
	else:
		line_mesh.clear_surfaces()
	
	return line_mesh

func setup_line_material():
	var mat := ShaderMaterial.new()
	mat.shader = SHADER
	material_override = mat

func raycast_query(pointA : Vector3, pointB : Vector3) -> Dictionary:
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(pointA, pointB, 1 << 0)
	query.hit_from_inside = false
	var result = space_state.intersect_ray(query)
	
	return result
