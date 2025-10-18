@tool
extends Node

## Utility Functions used frequently. From draw tools to geometrical wizards

#region ########## DRAW TOOLS ##############

## Stores lines that were requested to be drawn (for performance)
## {ID : [ImmediateMesh, ORMMaterial3D]}
var lines : Dictionary[String, Array]

## Draw 3D line in space with custom color
## Make ID random if you want to have single line instances
func draw_line(id : String, pos1: Vector3, pos2: Vector3, color : Color = Color.WHITE_SMOKE, no_depth : bool = false) -> void:

	# If line already exists
	if lines.has(id):
		lines[id][0].clear_surfaces()
		lines[id][0].surface_begin(Mesh.PRIMITIVE_LINES, lines[id][1])
		lines[id][0].surface_add_vertex(pos1)
		lines[id][0].surface_add_vertex(pos2)
		lines[id][0].surface_end()
	# If line doesn't exist, create one Material and Immediate Mesh for display
	else:
		var material := ORMMaterial3D.new()
		var mesh_instance := MeshInstance3D.new()
		var immediate_mesh := ImmediateMesh.new()

		mesh_instance.mesh = immediate_mesh
		mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		
		immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
		immediate_mesh.surface_add_vertex(pos1)
		immediate_mesh.surface_add_vertex(pos2)
		immediate_mesh.surface_end()

		material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		material.albedo_color = color
		material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		if no_depth: material.no_depth_test = true
		
		get_tree().get_root().add_child.call_deferred(mesh_instance)
		
		lines[id] = [immediate_mesh, material]

func draw_vector(id : String, pos1: Vector3, pos2: Vector3, color : Color = Color.WHITE_SMOKE, no_depth : bool = false) -> void:
	draw_line(id+"_vec_base", pos1, pos2, color, no_depth)
	
	var diff : Vector3 = pos1-pos2
	var rot_axis : Vector3 = Vector3.UP
	if abs(diff.dot(rot_axis)) > 0.95:
		rot_axis = Vector3.FORWARD
		
	draw_line(id+"_vec_arr", pos2 + (diff*0.1).rotated(rot_axis,  0.6), pos2, color, no_depth)
	draw_line(id+"_vec_ow", pos2 + (diff*0.1).rotated(rot_axis, -0.6), pos2, color, no_depth)
	
	
	
## Stores spheres that were requested to be drawn (for performance)
var spheres : Dictionary[String, MeshInstance3D]
## Draw 3D sphere in space with custom color
func draw_sphere(id : String, pos: Vector3, radius : float = 0.05, color : Color = Color.WHITE_SMOKE) -> void:
	# If sphere already exists
	if spheres.has(id):
		spheres[id].position = pos
		
	# If sphere doesn't exist
	else:
		var mesh_instance := MeshInstance3D.new()
		var sphere_mesh := SphereMesh.new()
		var material := ORMMaterial3D.new()

		mesh_instance.mesh = sphere_mesh
		mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		mesh_instance.position = pos

		sphere_mesh.radius = radius
		sphere_mesh.height = radius*2
		sphere_mesh.material = material

		material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		material.albedo_color = color
		
		get_tree().get_root().add_child.call_deferred(mesh_instance)
		
		spheres[id] = mesh_instance

## Draw cube in space with custom color

## Stores cubes that were requested to be drawn (for performance)
var cubes : Dictionary[String, MeshInstance3D]

func draw_cube(id : String, pos: Vector3, size: Vector3, color : Color = Color.WHITE) -> void:
	# If cube already exists
	if cubes.has(id):
		cubes[id].position = pos
		
	# If cube doesn't exist
	else:
		var mesh_instance := MeshInstance3D.new()
		var box_mesh := BoxMesh.new()
		var material := ORMMaterial3D.new()

		mesh_instance.mesh = box_mesh
		mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		mesh_instance.position = pos

		box_mesh.size = size
		box_mesh.material = material
		
		#Important to keep good performance on initialization
		material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		material.albedo_color = color
		
		get_tree().get_root().add_child.call_deferred(mesh_instance)
		
		cubes[id] = mesh_instance

## Draw 3D circle in space with custom color
func draw_circle(id : String, pos : Vector3, radius : float, direction : Vector3 = Vector3.UP, resolution : int = 48, color : Color = Color.WHITE) -> void:
	
	
	direction = direction.normalized()
	var circle_point : Vector3 = get_orthogonal_vector(direction) * radius
	print(get_orthogonal_vector(direction))
	var next_circle_point : Vector3
	
	for i in resolution:
		next_circle_point = circle_point.rotated(direction, 2*PI/resolution)
		draw_line(id+str(i), pos+circle_point, pos+next_circle_point, color)
		circle_point = next_circle_point

## Cleanup of 3D meshes for custom lifespan
## 1 -> Lasts ONLY for current physics frame
## >1 -> Lasts X time duration.
## <1 -> Stays indefinitely
func _final_cleanup(mesh_instance: MeshInstance3D, persist_ms: float) -> void:
	get_tree().get_root().add_child.call_deferred(mesh_instance)
	if persist_ms == 1:
		await get_tree().physics_frame
		mesh_instance.queue_free()
	elif persist_ms > 0:
		await get_tree().create_timer(persist_ms/1000).timeout
		mesh_instance.queue_free()
	else:
		return

#endregion

#region ####### GEOMETRICAL TOOLS ##########

## Returns a vector orthogonal to the input vector v
## by ensuring numerical stability even near axes
func get_orthogonal_vector(v: Vector3) -> Vector3:
	if abs(v.x) <= abs(v.y) and abs(v.x) <= abs(v.z):
		# x is the smallest magnitude
		return Vector3(0, -v.z, v.y)
	elif abs(v.y) <= abs(v.x) and abs(v.y) <= abs(v.z):
		# y is the smallest magnitude
		return Vector3(-v.z, 0, v.x)
	else:
		# z is the smallest magnitude
		return Vector3(-v.y, v.x, 0)

## Returns the closest point in a ray to another ray, useful for 3D mouse sliding
func closest_point_in_ray(ori_1: Vector3, dir_1: Vector3, ori_2: Vector3, dir_2: Vector3) -> Vector3:
	dir_1 = dir_1.normalized()
	dir_2 = dir_2.normalized()
	
	# Vector between origin of two lines
	var v : Vector3 = ori_1 - ori_2

	# Precompute dot products
	var dir_1_dot_dir_2 : float = dir_1.dot(dir_2)  # dir_1 ⋅ dir_2
	var v_dot_dir_1 : float = v.dot(dir_1)          # v ⋅ dir_1
	var v_dot_dir_2 : float = v.dot(dir_2)          # v ⋅ dir_2

	# Compute the determinant (simplified for normalized directions)
	var det_A : float = 1 - dir_1_dot_dir_2 * dir_1_dot_dir_2

	# Avoid division by zero in case lines are parallel
	if abs(det_A) < 1e-6:
		printerr("Warning: Parallel lines Returning origin of ray")
		# If parallel, project ori_1 onto line 2
		var projection : Vector3 = ori_2 + dir_2 * v_dot_dir_2
		return projection

	# Compute t using Cramer's rule
	var t : float = (v_dot_dir_2 - dir_1_dot_dir_2 * v_dot_dir_1) / det_A

	# The closest point on line is ori_2 + t * dir_2
	var closest_point_line : Vector3 = ori_2 + t * dir_2
	return closest_point_line

## Get line crossing through A and B,
## compute the vector starting at C
## that crosses this line
func perpendicular_vector_crossing(A: Vector3, B: Vector3, C: Vector3) -> Vector3:
	# Step 1: Compute the vector AB
	var AB : Vector3 = B - A
	
	# Step 2: Compute the vector perpendicular to AB
	var reference : Vector3 = Vector3.UP if AB != Vector3.UP else Vector3.FORWARD
	var perpendicular : Vector3 = AB.cross(reference).normalized()
	
	# Step 3: Compute the vector from A to C
	var AC : Vector3 = C - A
	
	# Step 4: Project AC onto the perpendicular direction
	var projection_length : float = AC.dot(perpendicular)
	var perpendicular_vector : Vector3 = projection_length * perpendicular
	
	return perpendicular_vector

#endregion

#region ######## OBJECT SPAWNERS ###########

func spawnCube(position : Vector3, size : Vector3 = Vector3(1,1,1), color : Color = Color.WHITE) -> MeshInstance3D:
	var mesh_instance := MeshInstance3D.new()
	var box_mesh := BoxMesh.new()
	var material := ORMMaterial3D.new()

	mesh_instance.mesh = box_mesh
	mesh_instance.position = position

	box_mesh.size = size
	box_mesh.material = material

	material.albedo_color = color
	
	get_tree().get_root().add_child.call_deferred(mesh_instance)

	return mesh_instance

func spawnSphere(parent:Node, position : Vector3, radius : float = 1, color : Color = Color.WHITE) -> MeshInstance3D:
	var mesh_instance := MeshInstance3D.new()
	var sphere_mesh := SphereMesh.new()
	var material := ORMMaterial3D.new()

	mesh_instance.mesh = sphere_mesh
	mesh_instance.position = position

	sphere_mesh.radius = radius
	sphere_mesh.height = radius*2
	sphere_mesh.material = material
	sphere_mesh.radial_segments = 32
	sphere_mesh.rings = 16

	material.albedo_color = color
	
	parent.add_child.call_deferred(mesh_instance)

	return mesh_instance

#endregion

#region ########## RANDOM TOOLS ############

func perlin_vector3(time: float, frequency : float, seed_value : int = 0) -> Vector3:
	var noise := FastNoiseLite.new()
	
	# Configure the noise settings
	noise.seed = seed_value # Randomize seed for varied results
	noise.frequency = frequency  # Adjust for smoother or more chaotic output
	noise.noise_type = FastNoiseLite.NoiseType.TYPE_VALUE_CUBIC
	noise.fractal_octaves = 1

	# Generate noise-based vectors
	var x : float = noise.get_noise_1d(time)
	var y : float = noise.get_noise_1d(time + 1000.0)
	var z : float = noise.get_noise_1d(time + 2000.0)

	return Vector3(x, y, z).normalized()
#endregion
