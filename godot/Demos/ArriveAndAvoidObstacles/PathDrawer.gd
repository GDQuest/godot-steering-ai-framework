extends Node2D


export var active_points := []
var is_drawing := true
var distance_threshold := 10.0



func _draw() -> void:
	for point in active_points:
		draw_circle(point, 2, Color.red)
	if active_points.size() > 0:
		draw_circle(active_points.front(), 2, Color.red)
		draw_circle(active_points.back(), 2, Color.yellow)
		draw_polyline(active_points, Color.skyblue, 1.0)

