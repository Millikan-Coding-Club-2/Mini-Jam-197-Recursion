@tool
extends Node2D

signal point_generated(value)

const RAINBOW = preload("uid://dtvhcsy5y1l65")

## Scene > Reload Saved Scene to restart script in editor
@export var run_in_editor := false
@export var color_coded := true
@export var draw_outline := true
@export var default_color := Color.RED
## Minimum of 3
@export var initial_point_count := 3
@export var initial_point_radius := 10.0
#@export var point_color := Color.RED
## Radius of the circumcircle of the regular polygon
@export var shape_scale := 50.0
@export var new_point_radius := 5.0

var initial_points: PackedVector2Array
var new_points: PackedVector2Array
var new_point_colors: PackedColorArray
# Should be automated by a script later
@export var timer_length := 0.2
var time := 0.0
var started := false
var point_value := 1

func start():
	started = true
	visible = true

## Generates the vertices of a regular n-gon
func generate_polygon(num_points := 3, radius := 1.0):
	num_points = maxi(3, num_points)
	var angle = 2*PI / num_points
	var points: PackedVector2Array
	for i in range(num_points):
		var curr_angle = angle * i - PI/2
		points.append(Vector2(cos(curr_angle) * radius,sin(curr_angle) * radius))
	return points
	
func draw_initial_points():
	if draw_outline:
		draw_circle(Vector2.ZERO, shape_scale * 1.5, Color.WHITE)
		draw_circle(Vector2.ZERO, shape_scale * 1.4, Color.BLACK)
	for i in range(initial_point_count):
		var color = RAINBOW.sample(float(i) / initial_point_count) if color_coded else default_color
		draw_circle(initial_points[i], initial_point_radius, color)
		
## points is the vertices of the original polygon; current is the last point generated
func get_next_point(points: PackedVector2Array, current: Vector2):
	var amount = points.size()
	var chosen_index = randi_range(0, amount - 1)
	var chosen = points[chosen_index]
	# https://beltoforion.de/en/recreational_mathematics/chaos_game.php
	var factor = float(amount) / (amount + 3)
	var next_point = current + (chosen - current) * factor
	new_point_colors.append(RAINBOW.sample(float(chosen_index) / amount))
	return next_point
	
func random_point_in_circle(radius: float) -> Vector2:
	var angle = randf_range(0, 2*PI)
	var normalized = Vector2(cos(angle), sin(angle))
	return normalized * radius * randf_range(0.0, 1.0)

func _ready() -> void:
	initial_points = generate_polygon(initial_point_count, shape_scale)
	# Approximates random point in the shape by getting random point in circumcircle
	new_point_colors.append(RAINBOW.sample(float(randi_range(0, initial_point_count)) / initial_point_count))
	
func _process(delta: float) -> void:
	if started and (not (Engine.is_editor_hint() and !run_in_editor)):
		if time >= timer_length:
			_timer()
			time = 0
		else: 
			time += delta

# This is where business goes down
func _draw():
	draw_initial_points()
	for i in range(new_points.size()):
		draw_circle(new_points[i], new_point_radius, new_point_colors[i] if color_coded else default_color)
	var new_point = random_point_in_circle(shape_scale) if new_points.is_empty() else get_next_point(initial_points, new_points[-1])
	new_points.append(new_point)

func _timer():
	queue_redraw()
	emit_signal("point_generated", point_value)
