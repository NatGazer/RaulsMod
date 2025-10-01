extends RigidBody3D

@export_group("Gears")
@export var base_gear_ratio : float = 4.2
@export var gear_ratios : PackedFloat32Array

@export_group("Motor")
@export var TORQUE : float = 300
@export var TORQUE_CURVE : Curve
@export var MAX_RPM : float = 6500
@export var MOTOR_FRICTION : float = 0.1
@export var AIR_FRICTION : float = 3E-6

@export_group("Steering Wheel")
@export var MAX_TURN_RADIUS : float = 5 # meters (average radius from wheel to turn center)
var  WHEELBASE : float # distance between front and rear axles
var  TRACK_WIDTH : float # distance between left and right wheels
var pivot_x : float

@export_group("Brakes")
@export var  BRAKE : float = 5400
@export var  HAND_BRAKE : float = BRAKE * 3

@export_group("Clutch")
@export var  CLUTCH_DISENGAGE_TIME : float = 0.2
@export var  CLUTCH_ENGAGE_TIME : float = 0.4

var MIN_SLIP_VELO : float = 1.5
var MAX_SLIP : float = 2 # Must be above 1

@export var torque_wheels : Array[Generic6DOFJoint3D]
@export var steering_wheels : Array[Generic6DOFJoint3D]
@export var all_and_brake_wheels : Array[Generic6DOFJoint3D]
@export var hand_brake_wheels : Array[Generic6DOFJoint3D]

var clutch : float = 1.0
var auto_shift : bool = true
var auto_shift_timer : float = 0.0
var gear : int = 0
var gear_ratio : float
var gear_tween : Tween
var motor_rpm : float
var wheels_rpm : float
var max_torque : float
var gear_box_torque : float
var wheels_torque  : float
var torque_wheel_amount : int
var torque_wheel_radius : Dictionary[Generic6DOFJoint3D, float]

func _ready() -> void:
	torque_wheel_amount = torque_wheels.size()
	
	## Compute Torque Wheel radius ##
	for wheel : Generic6DOFJoint3D in torque_wheels:
		for sibling : Node in wheel.get_parent().get_children():
			if sibling is CollisionShape3D:
				torque_wheel_radius[wheel] = sibling.shape.radius
				break
	
	## Find variables for Ackerman Steering ##
	_compute_wheel_geometry()

func _compute_wheel_geometry() -> void:
	var min_x := INF
	var max_x := -INF
	var min_z := INF
	var max_z := -INF
	var axle_positions: Dictionary = {}

	for wheel: Generic6DOFJoint3D in all_and_brake_wheels:
		var pos: Vector3 = %Chassi.to_local(wheel.global_position)

		min_x = min(min_x, pos.x)
		max_x = max(max_x, pos.x)
		min_z = min(min_z, pos.z)
		max_z = max(max_z, pos.z)

		axle_positions[pos.x] = (axle_positions.get(pos.x, []) as Array) + [wheel]

	WHEELBASE = max_x - min_x
	TRACK_WIDTH = max_z - min_z

	var steering_axles: Array[float] = []
	var fixed_axles: Array[float] = []

	for axle_x: float in axle_positions.keys():
		var wheels: Array = axle_positions[axle_x]
		if wheels.any(func(w: Generic6DOFJoint3D) -> bool: return steering_wheels.has(w)):
			steering_axles.append(axle_x)
		else:
			fixed_axles.append(axle_x)

	var target_axles : Array[float] = fixed_axles if not fixed_axles.is_empty() else steering_axles
	pivot_x = (target_axles.min() + target_axles.max()) / 2.0

func input_auto_shift(new_auto_shift : bool) -> void:
	auto_shift = new_auto_shift
	%UI.write_number("Auto Shift", int(auto_shift), 0)

func input_gear(new_gear : int) -> int:
	if new_gear+2 > gear_ratios.size() or new_gear < -1:
		return gear_ratios.size()
	
	if gear != new_gear:
		if gear_tween: gear_tween.kill()
		gear_tween = get_tree().create_tween() 
		gear_tween.tween_property(self, "clutch", 0, CLUTCH_DISENGAGE_TIME)
		gear_tween.tween_property(self, "clutch", 1, CLUTCH_ENGAGE_TIME)
	
	gear = new_gear
	gear_ratio = gear_ratios[gear+1] * base_gear_ratio
	%UI.write_number("Gear", gear, 0)
	
	return gear

func input_clutch_pedal(clutch_pedal : float) -> void:
	if gear_tween: return
	_set_clutch_engage(clutch_pedal)

func _set_clutch_engage(new_clutch: float) -> void:
	clutch = clampf(new_clutch, 0, 1)
	
func input_acc_pedal(acc_pedal : float) -> void:
	max_torque = TORQUE_CURVE.sample_baked(motor_rpm / MAX_RPM) * TORQUE
	gear_box_torque = acc_pedal * max_torque * gear_ratio
	wheels_torque = gear_box_torque * clutch
	#_set_engine_torque is now in Process to integrate motor_friction
	%UI.write_number("Torque", wheels_torque, 0)


func _set_engine_torque(new_torque : float) -> void:
	## Target Angular Velocity and adjust to avoid too much slip/acceleration
	var wheel_rel_torque : Dictionary[Generic6DOFJoint3D, float]
	var total_rel_torque : float = 0.0
	for wheel : Generic6DOFJoint3D in torque_wheels:
		wheel_rel_torque[wheel] = 1/pow(wheel_rpm(wheel)+0.1, 4)
		total_rel_torque += wheel_rel_torque[wheel]/torque_wheels.size()

	for wheel : Generic6DOFJoint3D in torque_wheels:
		wheel.set_flag_x(Generic6DOFJoint3D.FLAG_ENABLE_MOTOR, new_torque!=0.0)
		var diferential_torque = wheel_rel_torque[wheel] / total_rel_torque
		wheel.set_param_x(Generic6DOFJoint3D.PARAM_ANGULAR_MOTOR_FORCE_LIMIT, abs(new_torque) * diferential_torque)
		var direction : int = -1 if new_torque < 0 else 1
		wheel.set_param_x(Generic6DOFJoint3D.PARAM_ANGULAR_MOTOR_TARGET_VELOCITY, 999999*direction)

func input_steering_wheel(steering_wheel : float) -> void:
	
	# Turn radius from steering input
	var turn_radius = MAX_TURN_RADIUS / abs(steering_wheel)
	
	# Ackerman Steering
	for wheel: Generic6DOFJoint3D in steering_wheels:
		var pos: Vector3 = %Chassi.to_local(wheel.global_position)
		var dx: float = pos.x - pivot_x
		var dz: float = (TRACK_WIDTH / 2.0) * sign(pos.z)
		var angle: float = atan(dx / (turn_radius - dz))
		
		if steering_wheel < 0.0:
			angle = -angle
		
		_set_wheel_angle(wheel, angle)

func _set_wheel_angle(wheel: Generic6DOFJoint3D, angle: float) -> void:
	wheel.set_flag_y(Generic6DOFJoint3D.FLAG_ENABLE_ANGULAR_LIMIT, true)
	wheel.set_param_y(Generic6DOFJoint3D.PARAM_ANGULAR_LOWER_LIMIT, -angle)
	wheel.set_param_y(Generic6DOFJoint3D.PARAM_ANGULAR_UPPER_LIMIT, -angle)

## FIX ME BRAKES!!!!!!!!!
func input_brake_pedal(brake_pedal : float) -> void:
	_set_brake_torque(brake_pedal * BRAKE, all_and_brake_wheels)

func input_hand_brake_pedal(hand_brake_pedal : float) -> void:
	_set_brake_torque(hand_brake_pedal * HAND_BRAKE, hand_brake_wheels)

func _set_brake_torque(brake : float, wheels : Array[Generic6DOFJoint3D]):
	for wheel : Generic6DOFJoint3D in wheels:
		wheel.set_flag_x(Generic6DOFJoint3D.FLAG_ENABLE_MOTOR, brake > 0)
		wheel.set_param_x(Generic6DOFJoint3D.PARAM_ANGULAR_MOTOR_FORCE_LIMIT, brake)
		wheel.set_param_x(Generic6DOFJoint3D.PARAM_ANGULAR_MOTOR_TARGET_VELOCITY, 0)

func wheel_rpm(wheel : Generic6DOFJoint3D) -> float:
	var wheel_rb : RigidBody3D = wheel.get_parent()
	var wheel_ang_velocity : float = -(wheel_rb.angular_velocity * wheel_rb.global_basis).z
	return wheel_ang_velocity * 60 / (2*PI)

func _wheels_rpm() -> float:
	var rpm : float = 0.0
	for wheel : Generic6DOFJoint3D in torque_wheels:
		rpm += wheel_rpm(wheel)
	return rpm / torque_wheels.size()

func wheel_velocity() -> float:
	var velocity : float = 0.0
	for wheel:Generic6DOFJoint3D in torque_wheels:
		var wheel_rb : RigidBody3D = wheel.get_parent()
		velocity += (wheel_rb.angular_velocity * wheel_rb.basis).z * torque_wheel_radius[wheel]
	return velocity / torque_wheels.size()

func _physics_process(delta: float) -> void:
	wheels_rpm = _wheels_rpm()
	motor_rpm = lerpf(motor_rpm, wheels_rpm*gear_ratio, 20*delta)
	
	## Auto Shift ##
	auto_shift_timer += delta
	var gear_shift_delay_slow : float = (CLUTCH_DISENGAGE_TIME+CLUTCH_ENGAGE_TIME)*1.4
	var gear_shift_delay_fast : float = 0.2
	var gear_shift_delay : float = gear_shift_delay_fast if (gear_box_torque < max_torque * 0.1) else gear_shift_delay_slow
	if auto_shift and auto_shift_timer > gear_shift_delay:
		# Gear Up
		if (motor_rpm > 0.8 * MAX_RPM and gear < gear_ratios.size()-2) or gear <= 0:
			input_gear(gear + 1)
			auto_shift_timer = 0.0
		# Gear Down
		elif motor_rpm < max(800, MAX_RPM * 0.5) and gear > 1 and not (motor_rpm > MAX_RPM * 0.8):
			input_gear(gear - 1)
			auto_shift_timer = 0.0
		
	## Torque Management ##
	#Motor Friction
	var motor_friction : float = clutch * gear_ratio * gear_ratio * wheels_rpm * MOTOR_FRICTION*1E-3
	#Torque - Motor Friction
	_set_engine_torque(wheels_torque - motor_friction)
	# Air Friction
	var air_friction : float = pow(%Chassi.linear_velocity.length(), 2) * AIR_FRICTION * 1E-6
	%Chassi.linear_damp = air_friction
	
	%UI/RPM.speed = abs(motor_rpm) / 1000.0
	%UI/RPM/Gear.text = str(gear)
	%UI/Speedometer.speed = abs(wheel_velocity()*3.6)
	%UI.write_number("Clutch Engage", clutch*100, 0, "%")
	%UI.write_number("Air Friction", air_friction, 2)
	%UI.write_number("Motor Friction", motor_friction, 2)
	%UI.write_number("Motor RPM", motor_rpm, 0)
	%UI.write_number("Velocity", wheel_velocity()*3.6, 2, "km/h")
	%UI.write_number("Real velocity", linear_velocity.length()*3.6, 2, "km/h")
