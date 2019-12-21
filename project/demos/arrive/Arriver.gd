extends KinematicBody2D


onready var _radius: float = ($CollisionShape2D.shape as CircleShape2D).radius

onready var _agent: = GSTSteeringAgent.new()
onready var _target: = GSTAgentLocation.new()
onready var _arrive: = GSTArrive.new(_agent, _target)
onready var _accel: = GSTTargetAcceleration.new()

var _velocity: = Vector2()
var _drag: = 1.0


func _ready() -> void:
	_agent.max_linear_acceleration = 10
	_agent.max_linear_speed = 200
	_arrive.arrival_tolerance = 25
	_arrive.deceleration_radius = 225


func _draw() -> void:
	draw_circle(Vector2.ZERO, _radius, Color.red)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mb: InputEventMouseButton = event
		if mb.button_index == BUTTON_LEFT and mb.pressed:
			_target.position = Vector3(mb.position.x, mb.position.y, 0)
			owner.draw(Vector2(_target.position.x, _target.position.y))


func _physics_process(delta: float) -> void:
	_accel = _arrive.calculate_steering(_accel)
	_velocity += Vector2(_accel.linear.x, _accel.linear.y)
	_velocity -= _velocity * _drag * delta
	_velocity = move_and_slide(_velocity)
	_update_agent()


func _update_agent() -> void:
	_agent.position = Vector3(global_position.x, global_position.y, 0)
	_agent.linear_velocity = Vector3(_velocity.x, _velocity.y, 0)
