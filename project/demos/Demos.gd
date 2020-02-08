extends Node


onready var demo_picker: DemoPickerUI = $DemoPickerUI
onready var demo_player := $DemoPlayer
onready var button_go_back: Button = $ButtonGoBack


func _ready() -> void:
	demo_picker.connect("demo_requested", self, "_on_DemoPickerUI_demo_requested")
	button_go_back.connect("pressed", self, "_on_ButtonGoBack_pressed")


func _on_DemoPickerUI_demo_requested() -> void:
	demo_player.load_demo(demo_picker.demo_path)
	demo_picker.hide()
	button_go_back.show()


func _on_ButtonGoBack_pressed() -> void:
	demo_player.unload()
	button_go_back.hide()
	demo_picker.show()
