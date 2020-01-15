extends KinematicBody2D


onready var agent: = GSTAgentLocation.new()

export var speed: = 125.0


func _physics_process(delta: float) -> void:
	var movement: = _get_movement()
	move_and_slide(movement * speed)
	_update_agent()


func _get_movement() -> Vector2:
	return Vector2(	Input.get_action_strength("sf_right") - Input.get_action_strength("sf_left"),
					Input.get_action_strength("sf_down")  - Input.get_action_strength("sf_up"))


func _update_agent() -> void:
	agent.position = Vector3(global_position.x, global_position.y, 0)
