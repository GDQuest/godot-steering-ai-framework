extends KinematicBody2D
# Class to control the player in basic left/right up/down movement.


var speed: float
var agent := GSTAgentLocation.new()


func _physics_process(delta: float) -> void:
	var movement := _get_movement()
	if movement.length_squared() < 0.01:
		return
	
	move_and_slide(movement * speed)
	agent.position = Vector3(global_position.x, global_position.y, 0)


func _get_movement() -> Vector2:
	return Vector2(
			Input.get_action_strength("sf_right") - Input.get_action_strength("sf_left"),
			Input.get_action_strength("sf_down")  - Input.get_action_strength("sf_up"))
