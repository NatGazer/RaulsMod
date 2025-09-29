extends Node3D

const sensed_radius : float = 2.7

var active : bool = false

func _ready() -> void:
	$VehicleInput.leave_vehicle()

func activate() -> void:
	active = true
	Global.Camera.set_orbital_parent(%CamHolder, 5)
	$VehicleInput.process_mode = Node.PROCESS_MODE_INHERIT
	%UI.visible = true

func deactivate() -> void:
	active = false
	$VehicleInput.leave_vehicle()
	%UI.visible = false
	
func distance_to_player() -> float:
	return %Chassi.global_position.distance_to(Global.Player.position)
