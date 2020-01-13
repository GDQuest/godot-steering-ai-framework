extends Node2D


onready var gui: = $GUI
onready var pursuer: = $BoundaryManager/Pursuer
onready var seeker: = $BoundaryManager/Seeker

export var start_linear_speed: = 200.0
export var start_linear_accel: = 25.0
export var start_predict_time: = 0.3


func _ready() -> void:
	gui.connect("linear_accel_changed", self, "_on_GUI_linear_accel_changed")
	gui.connect("linear_speed_changed", self, "_on_GUI_linear_speed_changed")
	gui.connect("predict_time_changed", self, "_on_GUI_predict_time_changed")
	yield(get_tree(), "idle_frame")
	gui.linear_speed.value = start_linear_speed
	gui.linear_accel.value = start_linear_accel
	gui.predict_time.value = start_predict_time


func _on_GUI_linear_accel_changed(value: int) -> void:
	pursuer.agent.max_linear_acceleration = float(value)
	seeker.agent.max_linear_acceleration = float(value)


func _on_GUI_linear_speed_changed(value: int) -> void:
	pursuer.agent.max_linear_speed = float(value)
	seeker.agent.max_linear_speed = float(value)


func _on_GUI_predict_time_changed(value: int) -> void:
	pursuer._behavior.max_predict_time = float(value)
