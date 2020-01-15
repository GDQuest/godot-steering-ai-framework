extends KinematicBody2D


onready var agent: = GSTSteeringAgent.new()
onready var target: = GSTAgentLocation.new()
onready var arrive: = GSTArrive.new(agent, target)
var _accel: = GSTTargetAcceleration.new()

var _velocity: = Vector2()
var _drag: = 0.1


func _ready() -> void:
	agent.max_linear_speed = owner.max_linear_speed
	agent.max_linear_acceleration = owner.max_linear_accel
	agent.position = Vector3(global_position.x, global_position.y, 0)
	arrive.deceleration_radius = owner.deceleration_radius
	arrive.arrival_tolerance = owner.arrival_tolerance
	target.position = agent.position


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mb: InputEventMouseButton = event
		if mb.button_index == BUTTON_LEFT and mb.pressed:
			target.position = Vector3(mb.position.x, mb.position.y, 0)
			owner.target.position = mb.position


func _physics_process(delta: float) -> void:
	_update_agent()
	_accel = arrive.calculate_steering(_accel)
	_velocity += Vector2(_accel.linear.x, _accel.linear.y)
	_velocity = _velocity.linear_interpolate(Vector2.ZERO, _drag).clamped(agent.max_linear_speed)
	_velocity = move_and_slide(_velocity)


func _update_agent() -> void:
	agent.position = Vector3(global_position.x, global_position.y, 0)
	agent.linear_velocity = Vector3(_velocity.x, _velocity.y, 0)
