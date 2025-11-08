extends Node3D

@onready var cams_anim = $Cams
@onready var left = $Control/left
@onready var right = $Control/right
@onready var up = $Control/up
@onready var down = $Control/down

var current_cam = 0


# fnaf cams if statement monstrosity
func _on_left_mouse_entered():
	$sfx/crack1.play()
	if current_cam == 0:
		hide_arrows()
		cams_anim.play("left")
		await cams_anim.animation_finished
		right.show()
		current_cam = 3
	else:
		current_cam = 0
		hide_arrows()
		cams_anim.play_backwards("right")
		await cams_anim.animation_finished
		right.show()
		left.show()
		up.show()
func _on_right_mouse_entered():
	$sfx/crack2.play()
	if current_cam == 0:
		current_cam = 2
		hide_arrows()
		cams_anim.play("right")
		await cams_anim.animation_finished
		left.show()
	else:
		current_cam = 0
		hide_arrows()
		cams_anim.play_backwards("left")
		await cams_anim.animation_finished
		right.show()
		left.show()
		up.show()
func _on_up_mouse_entered():
	$sfx/crack3.play()
	current_cam = 1
	hide_arrows()
	cams_anim.play("up")
	await cams_anim.animation_finished
	down.show()
func _on_down_mouse_entered():
	$sfx/crack4.play()
	current_cam = 0
	hide_arrows()
	cams_anim.play_backwards("up")
	await cams_anim.animation_finished
	right.show()
	left.show()
	up.show()
func hide_arrows():
	left.hide()
	right.hide()
	up.hide()
	$Control/down.hide()
