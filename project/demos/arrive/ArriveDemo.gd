extends Node2D


onready var target: = $Target
onready var arriver: = $Arriver
onready var gui: = $GUI


func _ready() -> void:
	gui.connect("align_tolerance_changed", self, "_on_GUI_align_tolerance_changed")
	gui.connect("decel_radius_changed", self, "_on_GUI_decel_radius_changed")
	gui.connect("max_speed_changed", self, "_on_GUI_max_speed_changed")
	gui.connect("max_accel_changed", self, "_on_GUI_max_accel_changed")
	gui.max_speed.text = str(arriver._agent.max_linear_speed)
	gui.max_accel.text = str(arriver._agent.max_linear_acceleration)
	gui.arrival_tolerance.text = str(arriver._arrive.arrival_tolerance)
	gui.deceleration_radius.text = str(arriver._arrive.deceleration_radius)


func draw(location: Vector2) -> void:
	target.draw(location)


func _on_GUI_align_tolerance_changed(value: int) -> void:
	arriver._arrive.arrival_tolerance = value


func _on_GUI_decel_radius_changed(value: int) -> void:
	arriver._arrive.deceleration_radius = value


func _on_GUI_max_speed_changed(value: int) -> void:
	arriver._agent.max_linear_speed = value


func _on_GUI_max_accel_changed(value: int) -> void:
	arriver._agent.max_linear_acceleration = value
