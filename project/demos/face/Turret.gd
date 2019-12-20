extends KinematicBody2D


onready var _radius: float = ($CollisionShape2D.shape as CircleShape2D).radius
onready var _cannon: = Rect2(Vector2(-5, 0), Vector2(10, -_radius*2))
onready var _agent: = GSTSteeringAgent.new()
onready var _accel: = GSTTargetAcceleration.new()


var _angular_velocity: = 0.0
var _angular_drag: = 1.0
var _face: GSTFace


func _draw() -> void:
	draw_rect(_cannon, Color.blue)
	draw_circle(Vector2.ZERO, _radius, Color.teal)


func _physics_process(delta: float) -> void:
	if not _face:
		_setup()
	
	_accel = _face.calculate_steering(_accel)
	_angular_velocity += _accel.angular
	
	if _angular_velocity < 0:
		_angular_velocity += _angular_drag * delta
	elif _angular_velocity > 0:
		_angular_velocity -= _angular_drag * delta
	
	rotation += _angular_velocity * delta
	
	_update_agent()


func _update_agent() -> void:
	_agent.angular_velocity = _angular_velocity
	_agent.orientation = rotation


func _setup() -> void:
	_face = GSTFace.new(_agent, owner.player.agent)
	
	_face.alignment_tolerance = 0.1
	_face.deceleration_radius = PI/2
	
	_agent.max_angular_acceleration = 0.5
	_agent.max_angular_speed = 5
	_agent.position = Vector3(global_position.x, global_position.y, 0)
	
	_update_agent()
