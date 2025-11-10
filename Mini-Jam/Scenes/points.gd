extends Node2D

const DATAPOINT = preload("uid://bh80q7pd2hy1l")

func thingy(numba):
	var instance = DATAPOINT.instantiate()
	instance.position = get_global_mouse_position()
	add_child(instance)
	var anim_player = instance.get_node("AnimationPlayer")
	var label = instance.get_node("Label")
	label.text = "+"+str(numba)+" DP"
	anim_player.play("fly")
	await get_tree().create_timer(.6).timeout
	instance.queue_free()
