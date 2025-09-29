@tool
extends Node3D

enum {DONTJOIN, JOIN}

@export var create : bool :
	set(v):
		if Engine.is_editor_hint():
			_ready()
			
@export var always_create : bool = false

@export_range(0.01, 0.2) var global_thickness : float = 0.06
@export var global_material : StandardMaterial3D

func _ready() -> void:
	# Delete previous nodes inside and clear joints
	for child in get_children(true):
		if child is Generic6DOFJoint3D:
			child.node_a = ^""
			child.node_b = ^""
			
			var torque    : float = 500
			var velocity : float = 0
			child.set_flag_x(Generic6DOFJoint3D.FLAG_ENABLE_ANGULAR_SPRING, true)
			child.set_flag_y(Generic6DOFJoint3D.FLAG_ENABLE_ANGULAR_SPRING, true)
			child.set_flag_z(Generic6DOFJoint3D.FLAG_ENABLE_ANGULAR_SPRING, true)
			child.set_param_x(Generic6DOFJoint3D.PARAM_ANGULAR_MOTOR_FORCE_LIMIT, torque)
			child.set_param_y(Generic6DOFJoint3D.PARAM_ANGULAR_MOTOR_FORCE_LIMIT, torque)
			child.set_param_z(Generic6DOFJoint3D.PARAM_ANGULAR_MOTOR_FORCE_LIMIT, torque)
			child.set_param_x(Generic6DOFJoint3D.PARAM_ANGULAR_MOTOR_TARGET_VELOCITY, velocity)
			child.set_param_y(Generic6DOFJoint3D.PARAM_ANGULAR_MOTOR_TARGET_VELOCITY, velocity)
			child.set_param_z(Generic6DOFJoint3D.PARAM_ANGULAR_MOTOR_TARGET_VELOCITY, velocity)
			
		elif not child is Marker3D:
			child.free()
	
	#### Build Human Physique ###
	
	# Hip
	var hip := segment($rhip_thigh, $lhip_thigh, DONTJOIN)
	$rhip_thigh.node_a = hip.get_path()
	$lhip_thigh.node_a = hip.get_path()
	
	# Trunk
	var chest := segment($head_chest, $chest_abdomen, JOIN)
	segment($chest_abdomen, $abdomen_hip, JOIN)
	$abdomen_hip.node_b = hip.get_path()
	chest.freeze = true
		
	# Head
	var head := segment($Head, $head_chest, JOIN)
	$head_lshoulder.node_a = head.get_path()
	$head_rshoulder.node_a = head.get_path()
	
	# Left Arm
	var lshoulder := segment($head_lshoulder, $lshoulder_arm, JOIN)
	segment($lshoulder_arm, $larm_forearm, JOIN)
	segment($larm_forearm, $lforeharm_hand, JOIN)
	segment($lforeharm_hand, $lhand, JOIN)
	#lshoulder.freeze = true
	
	# Right Arm
	var rshoulder := segment($head_rshoulder, $rshoulder_arm, JOIN)
	segment($rshoulder_arm, $rarm_forearm, JOIN)
	segment($rarm_forearm, $rforeharm_hand, JOIN)
	segment($rforeharm_hand, $rhand, JOIN)
	
	# Left Leg
	segment($lhip_thigh, $lthigh_leg, JOIN)
	segment($lthigh_leg, $lleg_foot, JOIN)
	segment($lleg_foot, $lFoot, JOIN)
	
	# Right Leg
	segment($rhip_thigh, $rthigh_leg, JOIN)
	segment($rthigh_leg, $rleg_foot, JOIN)
	segment($rleg_foot, $rFoot, JOIN)
	
	# Avoid collisions in neck
	chest.collision_mask = 2
	lshoulder.collision_mask = 2
	rshoulder.collision_mask = 2


func _process(_delta: float) -> void:
	if always_create and Engine.is_editor_hint():
		_ready()


func segment(joint1 : Node3D, joint2 : Node3D, join : int) -> RigidBody3D:	
	# Compute variables
	var rb_pos : Vector3 = (joint1.position + joint2.position)/2
	
	var rb_basis : Basis
	var target : Vector3 = joint1.position.cross(joint2.position)
	if target.length() > 0.01:
		rb_basis = Basis.looking_at(target, joint2.position - joint1.position)
	var length : float = (joint2.position - joint1.position).length()
	
	# Create Rigid Body B
	var rigid_body = RigidBody3D.new()
	rigid_body.name = joint2.name.split("_")[0]
	rigid_body.position = rb_pos
	rigid_body.basis = rb_basis
	rigid_body.mass = joint1.get_meta("b_mass")
	add_child(rigid_body)
	
	# Collision Shape
	var capsule = CapsuleShape3D.new()
	capsule.height = length
	capsule.radius = global_thickness
	var col_shape = CollisionShape3D.new()
	col_shape.shape = capsule
	rigid_body.add_child(col_shape)
	
	# Mesh Instance
	var mesh = CapsuleMesh.new()
	mesh.height = length
	mesh.radius = global_thickness
	var mesh_intance = MeshInstance3D.new()
	mesh_intance.mesh = mesh
	mesh_intance.material_override = global_material
	rigid_body.add_child(mesh_intance)
	
	# Set joint connection points
	if join:
		if "node_b" in joint1 and joint1.node_b == ^"":
			joint1.node_b = rigid_body.get_path()
		if "node_a" in joint2 and joint2.node_a == ^"":
			joint2.node_a = rigid_body.get_path()
	
	return rigid_body
	
	
	
