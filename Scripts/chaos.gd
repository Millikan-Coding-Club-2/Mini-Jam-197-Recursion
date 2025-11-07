@tool
extends Node2D

## Scene > Reload Saved Scene to restart script in editor
@export var run_in_editor := true
## Minimum of 3
@export var initial_point_count := 3
@export var initial_point_radius := 10.0
@export var point_color := Color.RED
## Radius of the circumcircle of the regular polygon
@export var shape_scale := 50.0
@export var new_point_radius := 5.0

var initial_points: PackedVector2Array
var new_points: PackedVector2Array
# Should be automated by a script later
@export var timer_length := 0.2
var time := 0.0

## Generates the vertices of a regular n-gon
func generate_polygon(num_points := 3, radius := 1.0, center := Vector2.ZERO):
	num_points = maxi(3, num_points)
	var angle = 2*PI / num_points
	var points: PackedVector2Array
	for i in range(num_points):
		var curr_angle = angle * i - PI/2
		points.append(center + Vector2(cos(curr_angle) * radius,sin(curr_angle) * radius))
	return points
	
func draw_initial_points():
	for point in initial_points:
		draw_circle(point, initial_point_radius, point_color)
		
## points is the vertices of the original polygon; current is the last point generated
func get_next_point(points: PackedVector2Array, current: Vector2):
	var amount = points.size()
	var chosen = points[randi_range(0, amount - 1)]
	# https://beltoforion.de/en/recreational_mathematics/chaos_game.php
	var factor = float(amount) / (amount + 3)
	var next_point = current + (chosen - current) * factor
	return next_point
	
func random_point_in_circle(radius: float, center := Vector2.ZERO) -> Vector2:
	var angle = randf_range(0, 2*PI)
	var normalized = Vector2(cos(angle), sin(angle))
	return center + normalized * radius * randf_range(0.0, 1.0)

func _ready() -> void:
	initial_points = generate_polygon(initial_point_count, shape_scale)
	# Approximates random point in the shape by getting random point in circumcircle
	new_points.append(random_point_in_circle(shape_scale))
	
func _process(delta: float) -> void:
	if not (Engine.is_editor_hint() and !run_in_editor):
		if time >= timer_length:
			_timer()
			time = 0
		else: 
			time += delta

# This is where business goes down
func _draw():
	draw_initial_points()
	# Draw new points
	if new_points.size() == 1:
		draw_circle(new_points[0], new_point_radius, point_color)
	else:
		for point in new_points:
			draw_circle(point, new_point_radius, point_color)
	var new_point = get_next_point(initial_points, new_points[-1])
	new_points.append(new_point)

func _timer():
	queue_redraw()
