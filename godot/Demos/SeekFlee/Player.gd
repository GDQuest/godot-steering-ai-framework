extends CharacterBody2D
# Class to control the player in basic left/right up/down movement.

var speed: float
@onready var agent := GSAIAgentLocation.new()


func _ready() -> void:
	agent.position = GSAIUtils.to_vector3(global_position)


func _physics_process(_delta: float) -> void:
	var movement := _get_movement()
	if movement.length_squared() < 0.01:
		return

	# warning-ignore:return_value_discarded
	set_velocity(movement * speed)
	move_and_slide()
	agent.position = GSAIUtils.to_vector3(global_position)


func _get_movement() -> Vector2:
	return Vector2(
		Input.get_action_strength("sf_right") - Input.get_action_strength("sf_left"),
		Input.get_action_strength("sf_down") - Input.get_action_strength("sf_up")
	)
