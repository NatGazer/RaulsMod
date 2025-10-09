@tool
extends Node3D


@export var shader: Shader
@export var visible_instance_count: int = -1


## Class used to represent stars for StarManager. Passed to set_star_list().
class Star:
	# Position of the star.
	var position: Vector3
	# Luminosity of the star, relative to the luminosity of the Sun. (L☉)
	var luminosity: float
	# Temperature of the star, in kelvin.
	var temperature: float

	func _init(_position: Vector3, _luminosity: float, _temperature: float) -> void:
		self.position = _position
		self.luminosity = _luminosity
		self.temperature = _temperature


## Most stars have an "Effective temperature" which is the black body temperature that most closely
## matches their emitted spectra.
##
## This describes the color of the star as a single value, a temperature in Kelvin, from the range
## of ~500 through to 60,000 and beyond.
static func blackbody_to_rgb(kelvin: float) -> Color:
	var temperature: float = kelvin / 100.0
	var red: float
	var green: float
	var blue: float

	if temperature < 66.0:
		red = 255.0
	else:
		# Calculation for red component
		red = temperature - 55.0
		red = 351.97690566805693 + 0.114206453784165 * red - 40.25366309332127 * log(red)
		red = clamp(red, 0.0, 255.0)

	# Calculate green
	if temperature < 66.0:
		# Calculation for green component
		green = temperature - 2.0
		green = -155.25485562709179 - 0.44596950469579133 * green + 104.49216199393888 * log(green)
		green = clamp(green, 0.0, 255.0)
	else:
		# Calculation for green component
		green = temperature - 50.0
		green = 325.4494125711974 + 0.07943456536662342 * green - 28.0852963507957 * log(green)
		green = clamp(green, 0.0, 255.0)

	# Calculate blue
	if temperature >= 66.0:
		blue = 255.0
	else:
		if temperature <= 20.0:
			blue = 0.0
		else:
			# Calculation for blue component
			blue = temperature - 10.0
			blue = -254.76935184120902 + 0.8274096064007395 * blue + 115.67994401066147 * log(blue)
			blue = clamp(blue, 0.0, 255.0)

	return Color(red / 255.0, green / 255.0, blue / 255.0)


var material: ShaderMaterial
var mesh: MultiMesh

# This forwards the shader parameters, which would otherwise be inaccessible because the Material
# is generated at runtime.
func _get_property_list() -> Array[Dictionary]:
	var props: Array[Dictionary] = []
	if not shader:
		return props
	var shader_params: Array[Dictionary] = RenderingServer.get_shader_parameter_list(shader.get_rid())
	for p: Dictionary in shader_params:
		var cp: Dictionary = p.duplicate()
		cp["name"] = "shader_params/" + str(p["name"])
		props.append(cp)
	return props


func _get(p_key: StringName) -> Variant:
	var key: String = String(p_key)
	if key.begins_with("shader_params/"):
		var param_name: StringName = key.substr(len("shader_params/"))
		if material:
			return material.get_shader_parameter(param_name)
	return null


func _set(p_key: StringName, value: Variant) -> bool:
	var key: String = String(p_key)
	if key.begins_with("shader_params/"):
		var param_name: StringName = key.substr(len("shader_params/"))
		if material:
			material.set_shader_parameter(param_name, value)
			return true
	return false


# In order to render the stars without polluting the .tscn file with MultiMesh buffer data, this
# technique is used of creating the instance and adding it as a child in _init(). This somehow
# doesn't actually add the child to the scene in the editor, even though the code is running as a
# tool script.
func _init() -> void:
	material = ShaderMaterial.new()
	material.shader = shader

	var quad: QuadMesh = QuadMesh.new()
	quad.orientation = PlaneMesh.FACE_Z
	quad.size = Vector2(1, 1)
	quad.material = material

	mesh = MultiMesh.new()
	mesh.transform_format = MultiMesh.TRANSFORM_3D
	mesh.use_colors = true
	mesh.use_custom_data = true
	mesh.mesh = quad

	var inst: MultiMeshInstance3D = MultiMeshInstance3D.new()
	inst.multimesh = mesh

	add_child(inst)


func set_star_list(star_list: Array[Star]) -> void:
	# A safety check in case this function is called before the mesh is ready.
	if not is_instance_valid(mesh):
		return

	mesh.instance_count = star_list.size()

	for i: int in range(star_list.size()):
		var star: Star = star_list[i]
		var star_transform: Transform3D = Transform3D(Basis(), star.position)
		mesh.set_instance_transform(i, star_transform)
		mesh.set_instance_color(i, blackbody_to_rgb(star.temperature))
		mesh.set_instance_custom_data(i, Color(star.luminosity, 0, 0))


func _process(_delta: float) -> void:
	# Safety checks for tool script execution.
	if not is_instance_valid(material):
		return
	material.shader = shader
	
	if not is_instance_valid(mesh):
		return
	mesh.visible_instance_count = visible_instance_count
