extends "res://demos/pursue_vs_seek/Ship.gd"
# Controls the player ship's movements based on player input.


onready var agent: = GSTSteeringAgent.new()

export var thruster_strength: = 150.0
export var side_thruster_strength: = 10.0
export var max_velocity: = 150.0
export var max_angular_velocity: = 2.0
export var angular_drag: = 5.0
export var linear_drag: = 100.0

var _linear_velocity: = Vector2()
var _angular_velocity: = 0.0


func _physics_process(delta: float) -> void:
	var movement: = _get_movement()
	_angular_velocity = _calculate_angular_velocity(
		movement.x,
		_angular_velocity,
		side_thruster_strength,
		max_angular_velocity,
		angular_drag,
		delta
	)
	rotation += (_angular_velocity * delta)
	
	_linear_velocity = _calculate_linear_velocity(
		movement.y,
		_linear_velocity,
		Vector2.UP.rotated(rotation),
		linear_drag,
		thruster_strength,
		max_velocity,
		delta
	)
	
	_linear_velocity = move_and_slide(_linear_velocity)
	
	_update_agent(_linear_velocity, rotation)


func _calculate_angular_velocity(
		horizontal_movement: float,
		current_velocity: float,
		thruster_strength: float,
		max_velocity: float,
		ship_drag: float,
		delta: float) -> float:
	
	var velocity: = clamp(
		current_velocity + thruster_strength * horizontal_movement * delta,
		-max_velocity,
		max_velocity
	)
	
	if velocity > 0:
		velocity -= ship_drag * delta
	elif velocity < 0:
		velocity += ship_drag * delta
	if abs(velocity) < 0.01:
		velocity = 0
	
	return velocity


func _calculate_linear_velocity(
		vertical_movement: float,
		current_velocity: Vector2,
		facing_direction: Vector2,
		ship_drag: float,
		strength: float,
		max_speed: float,
		delta: float) -> Vector2:
	
	var actual_strength: = 0.0
	if vertical_movement > 0:
		actual_strength = strength
	elif vertical_movement < 0:
		actual_strength = -strength/1.5
	
	var velocity: = current_velocity + facing_direction * actual_strength * delta
	velocity -= current_velocity.normalized() * (ship_drag * delta)
	
	return velocity.clamped(max_speed)


func _get_movement() -> Vector2:
	return Vector2(	Input.get_action_strength("sf_right") - Input.get_action_strength("sf_left"),
					Input.get_action_strength("sf_up") - Input.get_action_strength("sf_down"))


func _update_agent(velocity: Vector2, orientation: float) -> void:
	agent.position.x = global_position.x
	agent.position.y = global_position.y
	agent.linear_velocity.x = velocity.x
	agent.linear_velocity.y = velocity.y
	agent.angular_velocity = _angular_velocity
	agent.orientation = orientation
