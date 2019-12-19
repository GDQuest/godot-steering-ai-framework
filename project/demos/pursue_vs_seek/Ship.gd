extends KinematicBody2D
"""
Draws a notched triangle based on the vertices of the ship's polygon collider.
"""


export var color: = Color()

var tag: int = 0

var _vertices: PoolVector2Array
var _colors: PoolColorArray


func _init(verts: = PoolVector2Array()) -> void:
	_vertices = verts


func _ready() -> void:
	if not _vertices:
		_vertices = $CollisionPolygon2D.polygon
	var centroid: = (_vertices[0] + _vertices[1] + _vertices[2])/3
	_vertices.insert(2, centroid)
	for i in range(_vertices.size()):
		_colors.append(color)


func _draw() -> void:
	draw_polygon(_vertices, _colors)
