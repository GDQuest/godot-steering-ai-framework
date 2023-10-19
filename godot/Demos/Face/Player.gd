extends CharacterBody2D

var speed: float

@onready var agent := GSAIAgentLocation.new()


func _physics_process(_delta: float) -> void:
	var movement := _get_movement()
	set_velocity(movement * speed)
	move_and_slide()
	agent.position = Vector3(global_position.x, global_position.y, 0)


func _get_movement() -> Vector2:
	return Vector2(
		Input.get_action_strength("sf_right") - Input.get_action_strength("sf_left"),
		Input.get_action_strength("sf_down") - Input.get_action_strength("sf_up")
	)
