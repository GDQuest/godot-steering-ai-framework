extends PanelContainer


signal linear_speed_changed(value)
signal linear_accel_changed(value)
signal angular_speed_changed(value)
signal angular_accel_changed(value)
signal decel_radius_changed(value)
signal predict_time_changed(value)


onready var linear_speed: = $GUI/Controls/LinSpeedBox/MaxLinSpeed
onready var lin_speed_label: = $GUI/Controls/LinSpeedBox/Label
onready var linear_accel: = $GUI/Controls/LinAccelBox/MaxLinAccel
onready var lin_accel_label: = $GUI/Controls/LinAccelBox/Label
onready var predict_time: = $GUI/Controls/PredictTime/PredictTime
onready var predict_time_label: = $GUI/Controls/PredictTime/Label


func _ready() -> void:
	linear_speed.connect("value_changed", self, "_on_Slider_linear_speed_changed")
	linear_accel.connect("value_changed", self, "_on_Slider_linear_accel_changed")
	predict_time.connect("value_changed", self, "_on_Slider_predict_time_changed")


func _on_Slider_linear_speed_changed(value: float) -> void:
	lin_speed_label.text = "Max linear speed (" + str(value) + ")"
	emit_signal("linear_speed_changed", value)


func _on_Slider_linear_accel_changed(value: float) -> void:
	lin_accel_label.text = "Max linear accel (" + str(value) + ")"
	emit_signal("linear_accel_changed", value)


func _on_Slider_predict_time_changed(value: float) -> void:
	predict_time_label.text = "Predict time (" + str(value) + " sec)"
	emit_signal("predict_time_changed", value)
