extends Node2D


onready var _gui: = $GUI
onready var _pursuer: = $BoundaryManager/Pursuer
onready var _seeker: = $BoundaryManager/Seeker


func _ready() -> void:
	_gui.linear_speed.text = str(_pursuer.agent.max_linear_speed)
	_gui.linear_accel.text = str(_pursuer.agent.max_linear_acceleration)
	_gui.connect("linear_accel_changed", self, "_on_GUI_linear_accel_changed")
	_gui.connect("linear_speed_changed", self, "_on_GUI_linear_speed_changed")


func _on_GUI_linear_accel_changed(value: int) -> void:
	_pursuer.agent.max_linear_acceleration = float(value)
	_seeker.agent.max_linear_acceleration = float(value)


func _on_GUI_linear_speed_changed(value: int) -> void:
	_pursuer.agent.max_linear_speed = float(value)
	_seeker.agent.max_linear_speed = float(value)
