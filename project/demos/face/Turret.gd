extends KinematicBody2D


onready var collision_shape: = $CollisionShape2D

var _cannon: Rect2

var _agent: = GSTSteeringAgent.new()
var _accel: = GSTTargetAcceleration.new()

var _angular_velocity: = 0.0
var _angular_drag: = 0.01
var _face: GSTFace


func _ready() -> void:
	var radius = collision_shape.shape.radius
	_cannon = Rect2(Vector2(-5, 0), Vector2(10, -radius*2))


func _draw() -> void:
	draw_rect(_cannon, Color.blue)


func _physics_process(delta: float) -> void:
	if not _face:
		return
	
	_accel = _face.calculate_steering(_accel)
	_angular_velocity += _accel.angular
	
	_angular_velocity = lerp(_angular_velocity, 0, _angular_drag)
	
	rotation += _angular_velocity * delta
	
	_update_agent()


func setup(
		align_tolerance: float,
		deceleration_radius: float,
		max_angular_accel: float,
		max_angular_speed: float
	) -> void:
	_face = GSTFace.new(_agent, owner.player.agent)
	
	_face.alignment_tolerance = align_tolerance
	_face.deceleration_radius = deceleration_radius
	
	_agent.max_angular_acceleration = max_angular_accel
	_agent.max_angular_speed = max_angular_speed
	_agent.position = Vector3(global_position.x, global_position.y, 0)
	
	_update_agent()


func _update_agent() -> void:
	_agent.angular_velocity = _angular_velocity
	_agent.orientation = rotation
