class_name DemoPickerUI
extends CenterContainer


signal demo_requested

var demo_path := "" setget set_demo_path

onready var list: ItemList = $VBoxContainer/ItemList
onready var button: Button = $VBoxContainer/Button


func _ready() -> void:
	list.connect("demo_selected", self, "set_demo_path")
	# I don't emit the demo_path as an argument as I've had type issues doing so
	list.connect("item_activated", self, "emit_signal", ["demo_requested"])
	button.connect("pressed", self, "emit_signal", ["demo_requested"])


func set_demo_path(value: String) -> void:
	demo_path = value
