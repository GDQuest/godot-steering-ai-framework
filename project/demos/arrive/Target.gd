extends Node2D


var target: = Vector2.ZERO


func _draw() -> void:
	draw_circle(target, 20, Color(1, 1, 0, 0.25))
	draw_circle(target, 5, Color.yellow)


func draw(location: Vector2) -> void:
	target = location
	update()
