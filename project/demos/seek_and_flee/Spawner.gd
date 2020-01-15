extends Node2D
# Holds data to instantiate and configure a number of agent entities.


export(PackedScene) var Entity: PackedScene
export var entity_count: = 10
export var entity_color: = Color.blue
export var max_speed: = 100.0
export var max_accel: = 20.0
