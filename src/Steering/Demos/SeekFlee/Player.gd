extends KinematicBody2D


onready var _radius: = ($CollisionShape2D.shape as CircleShape2D).radius

export var speed: = 150.0

var player_agent: = AgentLocation.new()


func _draw() -> void:
	draw_circle(Vector2.ZERO, _radius, Color.red)


func _get_movement() -> Vector2:
	return Vector2(Input.get_action_strength("sf_right") - Input.get_action_strength("sf_left"), 
			Input.get_action_strength("sf_down") - Input.get_action_strength("sf_up"))


func _physics_process(delta: float) -> void:
	var movement: = _get_movement()
	if movement.length_squared() < 0.01:
		return
	
	move_and_slide(movement * speed)
	player_agent.position = Vector3(global_position.x, global_position.y, 0)
