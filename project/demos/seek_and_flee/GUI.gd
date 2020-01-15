extends PanelContainer


enum BehaviorMode { SEEK, FLEE }

signal mode_changed(behavior_mode)
signal accel_changed(value)
signal speed_changed(value)

onready var seek: = $MarginContainer/BehaviorControls/Seek
onready var flee: = $MarginContainer/BehaviorControls/Flee
onready var max_accel: = $MarginContainer/BehaviorControls/MaxAccelValue
onready var max_speed: = $MarginContainer/BehaviorControls/MaxSpeedValue
onready var max_accel_label: = $MarginContainer/BehaviorControls/MaxAccel
onready var max_speed_label: = $MarginContainer/BehaviorControls/MaxSpeed


func _ready() -> void:
	seek.connect("pressed", self, "_on_Seek_pressed")
	flee.connect("pressed", self, "_on_Flee_pressed")
	max_accel.connect("value_changed", self, "_on_Accel_changed")
	max_speed.connect("value_changed", self, "_on_Speed_changed")
	max_accel_label.text = "Max accel (" + str(max_accel.value) + ")"
	max_speed_label.text = "Max speed (" + str(max_speed.value) + ")"


func _on_Seek_pressed() -> void:
	flee.pressed = false
	flee.button_mask = BUTTON_MASK_LEFT
	seek.button_mask = 0
	emit_signal("mode_changed", BehaviorMode.SEEK)


func _on_Flee_pressed() -> void:
	seek.pressed = false
	seek.button_mask = BUTTON_MASK_LEFT
	flee.button_mask = 0
	emit_signal("mode_changed", BehaviorMode.FLEE)


func _on_Accel_changed(value: float) -> void:
	max_accel_label.text = "Max accel (" + str(value) + ")"
	emit_signal("accel_changed", value)


func _on_Speed_changed(value: float) -> void:
	max_speed_label.text = "Max speed (" + str(value) + ")"
	emit_signal("speed_changed", value)
