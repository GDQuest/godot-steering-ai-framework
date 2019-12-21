extends MarginContainer


signal linear_speed_changed(value)
signal linear_accel_changed(value)


onready var linear_speed: = $Controls/LinSpeed/LineEdit
onready var linear_accel: = $Controls/LinAccel/LineEdit


func _ready() -> void:
	linear_speed.connect("text_changed", self, "_on_LineText_linear_speed_changed")
	linear_accel.connect("text_changed", self, "_on_LineText_linear_accel_changed")


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		linear_speed.release_focus()
		linear_accel.release_focus()


func _on_LineText_linear_speed_changed(new_text: String) -> void:
	if new_text.is_valid_integer():
		emit_signal("linear_speed_changed", int(float(new_text)))


func _on_LineText_linear_accel_changed(new_text: String) -> void:
	if new_text.is_valid_integer():
		emit_signal("linear_accel_changed", int(float(new_text)))
