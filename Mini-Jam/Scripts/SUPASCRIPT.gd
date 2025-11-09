extends Node3D

@onready var cams_anim = $Cams
@onready var left = $Control/left
@onready var right = $Control/right
@onready var up = $Control/up
@onready var down = $Control/down
# Monitor UI
@onready var data_point_label: Label = $"monitors/MainMonitor/HomeScreen/SubViewport/Screen/data_points/data"
@onready var dps: Label = $"monitors/MainMonitor/HomeScreen/SubViewport/Screen/data_points/dps"
@onready var monitor_label: Label = $monitors/MainMonitor/HomeScreen/SubViewport/Screen/monitor_label
@onready var upgrade_label: Label = $"monitors/MainMonitor/HomeScreen/SubViewport/Screen/monitor_label/upgrade frac/Button0/upgrade frac"

@export var initial_cost: int = 10
@export var upgrade_costs: Array[int]

var levels: Array[int] = [1, 1, 1]
var current_cam = 0

func _ready() -> void:
	upgrade_label.text = str(initial_cost) + " DP"
	upgrade_costs.resize(3)
	upgrade_costs.fill(initial_cost)
	
func cost_at_level(level: int) -> int:
	# TODO: I need my cookie clicker expert to revise this
	return initial_cost + int(pow(level, 2) / 2.0)

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

func _on_button_pressed(index: int) -> void:
	levels[index] += 1
	upgrade_label.text = str(cost_at_level(levels[index])) + " DP"
