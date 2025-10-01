extends Node

@onready var car : RigidBody3D = %Chassi

var clutch_pedal : float = 1.0
var acc_pedal : float
var steering_wheel : float
var brake_pedal : float
var hand_brake_pedal : float
var gear : int = 0
var auto_shift : bool = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Gear Up") and not auto_shift:
		gear = car.input_gear(gear+1)
	elif event.is_action_pressed("Gear Down") and not auto_shift:
		gear = car.input_gear(gear-1)
	
	elif event.is_action_pressed("AutoShift"):
		auto_shift = not auto_shift
		car.input_auto_shift(auto_shift)
		gear = car.gear

func _physics_process(delta: float) -> void:
	var input_clutch : int = 1-int(Input.is_action_pressed("Clutch"))
	var input_acc : int = int(Input.is_action_pressed("Accelerate"))
	var input_steering : int = int(Input.is_action_pressed("Left")) + -int(Input.is_action_pressed("Right"))
	var input_brake : int = int(Input.is_action_pressed("Brake"))
	var input_hand_brake : int = int(Input.is_action_pressed("HandBrake"))
	
	#LERP smoothing is broken, this fixes it
	var weight : float  = 1 - exp(-delta)
	
	clutch_pedal += (input_clutch - clutch_pedal) * weight * (3 + int(input_clutch==0)*10)
	acc_pedal += (input_acc - acc_pedal) * weight * (1 + int(input_acc==0)*20)
	steering_wheel += (input_steering - steering_wheel) * (weight * (1 + int(input_steering==0)*5) * 1.5)
	brake_pedal += (input_brake - brake_pedal) * (weight * (1 + int(input_brake==0)*5) * 15)
	hand_brake_pedal += (input_hand_brake - hand_brake_pedal) * (weight * (1 + int(input_hand_brake==0)*5) * 15)

	if brake_pedal >= 0.01:
		acc_pedal = 0.0
	
	car.input_clutch_pedal(clutch_pedal)
	car.input_brake_pedal(brake_pedal)
	car.input_hand_brake_pedal(hand_brake_pedal)
	car.input_acc_pedal(acc_pedal)
	car.input_steering_wheel(steering_wheel)

func leave_vehicle() -> void:
	car.input_acc_pedal(0)
	car.input_steering_wheel(0)
	car.input_brake_pedal(1)
	process_mode = Node.PROCESS_MODE_DISABLED
