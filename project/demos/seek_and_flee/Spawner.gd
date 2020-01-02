extends Node2D
# Holds data to instantiate and configure a number of agent entities.


export(PackedScene) var Entity: PackedScene
export var entity_count: = 10
export var entity_color: = Color.blue
export var min_speed: = 50.0
export var max_speed: = 125.0
