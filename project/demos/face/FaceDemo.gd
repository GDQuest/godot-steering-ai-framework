extends Node2D


onready var player: = $Player
onready var gui: = $GUI
onready var turret: = $Turret


func _ready() -> void:
	gui.connect("align_tolerance_changed", self, "_on_GUI_align_tolerance_changed")
	gui.connect("decel_radius_changed", self, "_on_GUI_decel_radius_changed")
	gui.connect("max_accel_changed", self, "_on_GUI_max_accel_changed")
	gui.connect("max_speed_changed", self, "_on_GUI_max_speed_changed")
	turret.setup()
	gui.align_tolerance.text = str(int(rad2deg(turret._face.alignment_tolerance)))
	gui.decel_radius.text = str(int(rad2deg(turret._face.deceleration_radius)))
	gui.max_speed.text = str(int(rad2deg(turret._agent.max_angular_speed)))
	gui.max_accel.text = str(int(rad2deg(turret._agent.max_angular_acceleration)))


func _on_GUI_align_tolerance_changed(value: int) -> void:
	turret._face.alignment_tolerance = deg2rad(value)


func _on_GUI_decel_radius_changed(value: int) -> void:
	turret._face.deceleration_radius = deg2rad(value)


func _on_GUI_max_accel_changed(value: int) -> void:
	turret._agent.max_angular_acceleration = deg2rad(value)


func _on_GUI_max_speed_changed(value: int) -> void:
	turret._agent.max_angular_speed = deg2rad(value)
