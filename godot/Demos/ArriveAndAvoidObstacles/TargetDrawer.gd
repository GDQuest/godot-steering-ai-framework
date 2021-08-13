extends Node2D

const COLORS := {
	deceleration_radius = Color(1.0, 0.419, 0.592, 0.5),
	arrival_tolerance = Color(0.278, 0.231, 0.47, 0.3)
}

var target_position := Vector2.ZERO

func _ready() -> void:
	yield(owner, "ready")


func _draw():
	draw_circle(target_position, owner.deceleration_radius, COLORS.deceleration_radius)
	draw_circle(target_position, owner.arrival_tolerance, COLORS.arrival_tolerance)
