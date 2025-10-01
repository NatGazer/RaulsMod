extends Node3D

var parent : Node3D

func _ready() -> void:
	parent = get_parent()
	top_level = true


func _physics_process(_delta: float) -> void:
	global_position = parent.global_position
