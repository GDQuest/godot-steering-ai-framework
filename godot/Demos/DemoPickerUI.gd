class_name DemoPickerUI
extends Control

# warning-ignore:unused_signal
signal demo_requested

var demo_path := "" setget set_demo_path

onready var list: ItemList = $VBoxContainer/ItemList
onready var button: Button = $VBoxContainer/Button


func _ready() -> void:
	# warning-ignore:return_value_discarded
	list.connect("demo_selected", self, "set_demo_path")
	# warning-ignore:return_value_discarded
	list.connect("item_activated", self, "_on_ItemList_item_activated")
	# warning-ignore:return_value_discarded
	button.connect("pressed", self, "emit_signal", ["demo_requested"])
	demo_path = list.file_paths[0]


func set_demo_path(value: String) -> void:
	demo_path = value


func _on_ItemList_item_activated(_index: int) -> void:
	emit_signal("demo_requested")
