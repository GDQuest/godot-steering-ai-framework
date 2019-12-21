extends Node2D


onready var _target: = $Target


func draw(location: Vector2) -> void:
	_target.draw(location)
