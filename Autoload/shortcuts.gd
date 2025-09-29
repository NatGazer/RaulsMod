extends Node

var slow_mo_tween : Tween

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("release_mouse"):
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if event.is_action_pressed("FullScreen"):
		if DisplayServer.window_get_mode(0) == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	
	if event.is_action_pressed("SlowMotion"):
		if slow_mo_tween: slow_mo_tween.kill()
		slow_mo_tween = get_tree().create_tween()
		slow_mo_tween.tween_property(Engine, "time_scale", 0.1, 0.5)
		slow_mo_tween.parallel()
		slow_mo_tween.tween_method(set_global_pitch, 1.0, 0.1, 0.5)
		#set_global_pitch(0.1)
	
	if event.is_action_released("SlowMotion"):
		if slow_mo_tween: slow_mo_tween.kill()
		slow_mo_tween = get_tree().create_tween()
		slow_mo_tween.tween_property(Engine, "time_scale", 1.0, 0.5)
		slow_mo_tween.parallel()
		slow_mo_tween.tween_method(set_global_pitch, 0.1, 1.0, 0.5)

func set_global_pitch(pitch : float) -> void:
	var bus_idx = AudioServer.get_bus_index("Master")
	for i in range(AudioServer.get_bus_effect_count(bus_idx)):
		var effect_res: AudioEffect = AudioServer.get_bus_effect(bus_idx, i) # This is the *resource*
		if effect_res is AudioEffectPitchShift:
			(effect_res as AudioEffectPitchShift).pitch_scale = pitch
			return
