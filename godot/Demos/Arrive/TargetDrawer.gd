extends Node2D

const COLORS := {
	deceleration_radius = Color(1.0, 0.419, 0.592, 0.5),
	arrival_tolerance = Color(0.278, 0.231, 0.47, 0.3)
}

var arriver: Node2D


func _ready() -> void:
	await owner.ready
	arriver = owner.arriver


func _draw():
	var target_position := GSAIUtils.to_vector2(arriver.target.position)
	draw_circle(target_position, owner.deceleration_radius, COLORS.deceleration_radius)
	draw_circle(target_position, owner.arrival_tolerance, COLORS.arrival_tolerance)

