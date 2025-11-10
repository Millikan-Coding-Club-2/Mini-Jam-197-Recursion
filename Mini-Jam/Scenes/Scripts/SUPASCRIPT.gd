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

## Index of labels (SPEED_COST = 0, SPEED_LEVEL = 1...)
enum {SPEED_COST, SPEED_LEVEL, VERT_COST, VERT_LEVEL}
## Type of upgrade
enum {SPEED_UP, VERTEX_UPGRADE}

func _ready() -> void:
	OMEGA_upgrade_labels = [upgrade_labels1, upgrade_labels2, upgrade_labels3]
	for labels in OMEGA_upgrade_labels:
		labels[0].text = str(initial_speed_cost) + " DP"
		labels[2].text = str(initial_vert_cost) + " DP"
	chaoses[0].start()
	update_dps()

func cost_at_level(type, level: int) -> int:
	## TODO: I need my cookie clicker expert to revise this
	match type:
		SPEED_UP:
			return initial_speed_cost + int(pow(level, 2) / 2.0)
		VERTEX_UPGRADE:
			return initial_vert_cost + int(pow(level, 3) / 2.0)
		_:
			return int("you IDIOT")
			
func update_dps():
	dps = 0
	for fractal in chaoses:
		if fractal.get("started") == true:
			dps += fractal.get("point_value")  * (1/fractal.get("timer_length"))

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

## index is the index of the button of the selected monitor (0 or 1)
func _on_button_pressed(monitor_idx: int, index: int) -> void:
	# Uncomment this and it should make sense
	#print("Clicked monitor " + str(monitor_idx) + ", index " + str(index))
	var cost = cost_at_level(index, levels[monitor_idx][index])
	if data_points >= cost: # Can afford upgrade
		var cost_idx: int
		var level_idx: int
		var curr_monitor = OMEGA_upgrade_labels[monitor_idx]
		levels[monitor_idx][index] += 1
		data_points -= cost
		var fractal = chaoses[monitor_idx]
		match index:
			SPEED_UP:
				cost_idx = SPEED_COST
				level_idx = SPEED_LEVEL
				fractal.speed_up()
			VERTEX_UPGRADE:
				cost_idx = VERT_COST
				level_idx = VERT_LEVEL
				fractal.add_vert()
				var vertex_count = str(3 + levels[monitor_idx][VERTEX_UPGRADE] - 1)
				monitor_labels[monitor_idx].text = "MONITOR " + str(monitor_idx+1) + ": " + vertex_count + " VERTICES"
				levels[monitor_idx][SPEED_UP] = 1
				curr_monitor[SPEED_COST].text = str(initial_speed_cost) + " DP"
				curr_monitor[SPEED_LEVEL].text = "Lv. " + str(levels[monitor_idx][SPEED_UP])
				fractal.restart()
		update_dps()
		var new_cost = str(cost_at_level(index, levels[monitor_idx][index])) + " DP"
		curr_monitor[cost_idx].text = new_cost
		var new_level = "Lv. " + str(levels[monitor_idx][index])
		curr_monitor[level_idx].text = new_level
	else: # Can't afford upgrade
		pass

func _on_chaos_point_generated(value: int) -> void:
	data_points += value
