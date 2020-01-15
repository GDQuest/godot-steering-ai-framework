extends Node2D


onready var drawer: = $Drawer 


func _ready() -> void:
	$PathFollower.setup()
