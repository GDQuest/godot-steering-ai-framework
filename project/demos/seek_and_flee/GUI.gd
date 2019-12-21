extends MarginContainer


enum BehaviorMode { SEEK, FLEE }

signal mode_changed(behavior_mode)

onready var seek: CheckBox = $BehaviorControls/Seek
onready var flee: CheckBox = $BehaviorControls/Flee


func _ready() -> void:
	seek.connect("pressed", self, "_on_Seek_pressed")
	flee.connect("pressed", self, "_on_Flee_pressed")


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
