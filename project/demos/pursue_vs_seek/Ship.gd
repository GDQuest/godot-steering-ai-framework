extends KinematicBody2D
# Represents a basic ship


var tag: int = 0


func generate_sprite(sprite: Sprite) -> void:
	var new_sprite = Sprite.new()
	new_sprite.texture = sprite.texture
	new_sprite.modulate = sprite.modulate
	new_sprite.name = "Sprite"
	add_child(new_sprite)
