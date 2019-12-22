extends Node2D


onready var _target: = $Target
onready var _arriver: = $Arriver
onready var _gui: = $GUI


func _ready() -> void:
	_gui.connect("align_tolerance_changed", self, "_on_GUI_align_tolerance_changed")
	_gui.connect("decel_radius_changed", self, "_on_GUI_decel_radius_changed")
	_gui.connect("max_speed_changed", self, "_on_GUI_max_speed_changed")
	_gui.connect("max_accel_changed", self, "_on_GUI_max_accel_changed")
	_gui.max_speed.text = str(_arriver._agent.max_linear_speed)
	_gui.max_accel.text = str(_arriver._agent.max_linear_acceleration)
	_gui.arrival_tolerance.text = str(_arriver._arrive.arrival_tolerance)
	_gui.deceleration_radius.text = str(_arriver._arrive.deceleration_radius)


func draw(location: Vector2) -> void:
	_target.draw(location)


func _on_GUI_align_tolerance_changed(value: int) -> void:
	_arriver._arrive.arrival_tolerance = value


func _on_GUI_decel_radius_changed(value: int) -> void:
	_arriver._arrive.deceleration_radius = value


func _on_GUI_max_speed_changed(value: int) -> void:
	_arriver._agent.max_linear_speed = value


func _on_GUI_max_accel_changed(value: int) -> void:
	_arriver._agent.max_linear_acceleration = value
