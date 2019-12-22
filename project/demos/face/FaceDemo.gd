extends Node2D


onready var player: = $Player
onready var _gui: = $GUI
onready var _turret: = $Turret


func _ready() -> void:
	_gui.connect("align_tolerance_changed", self, "_on_GUI_align_tolerance_changed")
	_gui.connect("decel_radius_changed", self, "_on_GUI_decel_radius_changed")
	_gui.connect("max_accel_changed", self, "_on_GUI_max_accel_changed")
	_gui.connect("max_speed_changed", self, "_on_GUI_max_speed_changed")
	_turret.setup()
	_gui.align_tolerance.text = str(int(rad2deg(_turret._face.alignment_tolerance)))
	_gui.decel_radius.text = str(int(rad2deg(_turret._face.deceleration_radius)))
	_gui.max_speed.text = str(int(rad2deg(_turret._agent.max_angular_speed)))
	_gui.max_accel.text = str(int(rad2deg(_turret._agent.max_angular_acceleration)))


func _on_GUI_align_tolerance_changed(value: int) -> void:
	_turret._face.alignment_tolerance = deg2rad(value)


func _on_GUI_decel_radius_changed(value: int) -> void:
	_turret._face.deceleration_radius = deg2rad(value)


func _on_GUI_max_accel_changed(value: int) -> void:
	_turret._agent.max_angular_acceleration = deg2rad(value)


func _on_GUI_max_speed_changed(value: int) -> void:
	_turret._agent.max_angular_speed = deg2rad(value)
