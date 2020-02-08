extends CenterContainer


onready var list := $VBoxContainer/ItemList
onready var button := $VBoxContainer/Button
var selected_demo: String


func _ready() -> void:
	button.connect("button_down", self, "_on_Button_down")
	button.disabled = true
	list.connect("item_selected", self, "_on_ItemList_item_selected")
	list.connect("item_activated", self, "_on_ItemList_item_activated")


func _on_Button_down() -> void:
	get_tree().change_scene(selected_demo)


func _on_ItemList_item_selected(index: int) -> void:
	selected_demo = list.file_paths[index]
	button.disabled = false


func _on_ItemList_item_activated(index: int) -> void:
	_on_Button_down()
