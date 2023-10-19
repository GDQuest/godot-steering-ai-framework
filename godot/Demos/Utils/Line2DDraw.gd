@tool
extends Line2D

@export var inner_color := Color(): set = set_inner_color


func _draw() -> void:
	draw_colored_polygon(points, inner_color)


func set_inner_color(val: Color) -> void:
	inner_color = val
	queue_redraw()
