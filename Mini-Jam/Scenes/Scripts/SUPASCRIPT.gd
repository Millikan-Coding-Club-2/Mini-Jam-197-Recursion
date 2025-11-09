extends Node3D

@onready var cams_anim = $Cams
@onready var left = $Control/left
@onready var right = $Control/right
@onready var up = $Control/up
@onready var down = $Control/down
# Monitor UI
@onready var data_point_label: Label = $"monitors/MainMonitor/HomeScreen/SubViewport/Screen/data_points/data"
@onready var dps_label: Label = $"monitors/MainMonitor/HomeScreen/SubViewport/Screen/data_points/dps"
@export var monitor_labels: Array[Label]
@export var upgrade_labels1: Array[Label]
@export var upgrade_labels2: Array[Label]
@export var upgrade_labels3: Array[Label]
var OMEGA_upgrade_labels: Array
@export var chaoses: Array[Node2D]

@export var initial_speed_cost: int = 10
@export var initial_vert_cost: int = 100

var dps:
	set(value):
		dps_label.text = str(value) + " DP/s"
		dps = value
var levels: Array[Array] = [[1, 1], [1, 1], [1, 1]]
var data_points = 0:
	set(value):
		data_point_label.text = str(value)
		data_points = value
var current_cam = 0

enum {SPEED_COST, SPEED_LEVEL, VERT_COST, VERT_LEVEL}
enum {VERTEX_UPGRADE, SPEED_UP}

func _ready() -> void:
	OMEGA_upgrade_labels = [upgrade_labels1, upgrade_labels2, upgrade_labels3]
	chaoses[0].start()
	
	
func cost_at_level(type, level: int) -> int:
	## TODO: I need my cookie clicker expert to revise this
	match type:
		VERTEX_UPGRADE:
			return initial_vert_cost + int(pow(level, 3) / 2.0)
		SPEED_UP:
			return initial_speed_cost + int(pow(level, 2) / 2.0)
		_:
			return int("you IDIOT")
	

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

func _on_button_pressed(monitor_idx: int, index) -> void:
	#print("Clicked monitor " + str(monitor_idx) + ", index " + str(index))
	# Returns level label corresponding to button pressed
	var label_idx = SPEED_LEVEL + index*2
	levels[monitor_idx][index] += 1
	var new_text = "Lv. " + str(levels[monitor_idx][index])
	OMEGA_upgrade_labels[monitor_idx][label_idx].text = new_text
	#upgrade_label.text = str(cost_at_level(VERTEX_UPGRADE, levels[index])) + " DP"

func _on_chaos_point_generated(value: int) -> void:
	data_points += value
