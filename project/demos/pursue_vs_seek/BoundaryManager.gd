extends Node2D
# Wraps the ships' positions around the world border, and controls their rendering clones.


onready var ShipType: = preload("res://demos/pursue_vs_seek/Ship.gd")
onready var ships: = [$Player, $Pursuer, $Seeker]

var _clones: = {}
var _world_bounds: Vector2


func _ready() -> void:
	_world_bounds = Vector2(
			ProjectSettings["display/window/size/width"],
			ProjectSettings["display/window/size/height"]
	)
	
	for i in range(ships.size()):
		var ship: Node2D = ships[i]
		var world_pos: = ship.position
		
		for i in range(3):
			var ship_clone: = ShipType.new($Player/CollisionPolygon2D.polygon)
			
			ship_clone.position.x = world_pos.x if i == 1 else (world_pos.x - _world_bounds.x)
			ship_clone.position.y = world_pos.y if i == 0 else (world_pos.y - _world_bounds.y)
			ship_clone.rotation = ship.rotation
			ship_clone.color = ship.color
			ship_clone.tag = i
			
			add_child(ship_clone)
			_clones[ship_clone] = ship


func _physics_process(delta: float) -> void:
	for clone in _clones.keys():
		var original: Node2D = _clones[clone]
		var world_pos: Vector2 = original.position
		
		if world_pos.y < 0:
			original.position.y = _world_bounds.y + world_pos.y
		elif world_pos.y > _world_bounds.y:
			original.position.y = (world_pos.y - _world_bounds.y)
		
		if world_pos.x < 0:
			original.position.x = _world_bounds.x + world_pos.x
		elif world_pos.x > _world_bounds.x:
			original.position.x = (world_pos.x - _world_bounds.x)
		
		var tag: int = clone.tag
		if tag != 2:
			if world_pos.x < _world_bounds.x/2:
				clone.position.x = world_pos.x + _world_bounds.x
			else:
				clone.position.x = world_pos.x - _world_bounds.x
		else:
			clone.position.x = world_pos.x
		
		if tag != 0:
			if world_pos.y < _world_bounds.y/2:
				clone.position.y = world_pos.y + _world_bounds.y
			else:
				clone.position.y = world_pos.y - _world_bounds.y
		else:
			clone.position.y = world_pos.y
		clone.rotation = original.rotation
