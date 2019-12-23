extends Node2D


onready var gui: = $GUI
onready var pursuer: = $BoundaryManager/Pursuer
onready var seeker: = $BoundaryManager/Seeker


func _ready() -> void:
	gui.linear_speed.text = str(pursuer.agent.max_linear_speed)
	gui.linear_accel.text = str(pursuer.agent.max_linear_acceleration)
	gui.connect("linear_accel_changed", self, "_on_GUI_linear_accel_changed")
	gui.connect("linear_speed_changed", self, "_on_GUI_linear_speed_changed")


func _on_GUI_linear_accel_changed(value: int) -> void:
	pursuer.agent.max_linear_acceleration = float(value)
	seeker.agent.max_linear_acceleration = float(value)


func _on_GUI_linear_speed_changed(value: int) -> void:
	pursuer.agent.max_linear_speed = float(value)
	seeker.agent.max_linear_speed = float(value)
