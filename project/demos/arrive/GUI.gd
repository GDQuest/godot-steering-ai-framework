extends MarginContainer


signal max_speed_changed(value)
signal max_accel_changed(value)
signal align_tolerance_changed(value)
signal decel_radius_changed(value)

onready var max_speed: = $Controls/MaxSpeed/LineEdit
onready var max_accel: = $Controls/MaxAccel/LineEdit
onready var arrival_tolerance: = $Controls/ArrivalTolerance/LineEdit
onready var deceleration_radius: = $Controls/DecelRadius/LineEdit


func _ready() -> void:
	max_speed.connect("text_changed", self, "_on_MaxSpeed_text_changed")
	max_accel.connect("text_changed", self, "_on_MaxAccel_text_changed")
	arrival_tolerance.connect("text_changed", self, "_on_ArrivalTolerance_text_changed")
	deceleration_radius.connect("text_changed", self, "_on_DecelerationRadius_text_changed")


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		max_speed.release_focus()
		max_accel.release_focus()
		arrival_tolerance.release_focus()
		deceleration_radius.release_focus()


func _on_MaxSpeed_text_changed(new_text: String) -> void:
	if new_text.is_valid_integer():
		emit_signal("max_speed_changed", int(float(new_text)))


func _on_MaxAccel_text_changed(new_text: String) -> void:
	if new_text.is_valid_integer():
		emit_signal("max_accel_changed", int(float(new_text)))


func _on_ArrivalTolerance_text_changed(new_text: String) -> void:
	if new_text.is_valid_integer():
		emit_signal("align_tolerance_changed", int(float(new_text)))


func _on_DecelerationRadius_text_changed(new_text: String) -> void:
	if new_text.is_valid_integer():
		emit_signal("decel_radius_changed", int(float(new_text)))
