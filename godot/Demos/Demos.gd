extends Node

@onready var demo_picker: DemoPickerUI = $DemoPickerUI
@onready var demo_player := $DemoPlayer
@onready var button_go_back: Button = $ButtonGoBack


func _ready() -> void:
	# warning-ignore:return_value_discarded
	demo_picker.connect("demo_requested", Callable(self, "_on_DemoPickerUI_demo_requested"))
	# warning-ignore:return_value_discarded
	button_go_back.connect("pressed", Callable(self, "_on_ButtonGoBack_pressed"))


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_fullscreen"):
		get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (not ((get_window().mode == Window.MODE_EXCLUSIVE_FULLSCREEN) or (get_window().mode == Window.MODE_FULLSCREEN))) else Window.MODE_WINDOWED
		get_viewport().set_input_as_handled()


func _on_DemoPickerUI_demo_requested() -> void:
	demo_player.load_demo(demo_picker.demo_path)
	demo_picker.hide()
	button_go_back.show()


func _on_ButtonGoBack_pressed() -> void:
	demo_player.unload()
	button_go_back.hide()
	demo_picker.show()
