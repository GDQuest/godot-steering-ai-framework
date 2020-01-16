extends KinematicBody2D


var face: GSTFace
var agent := GSTSteeringAgent.new()

var _accel := GSTTargetAcceleration.new()
var _angular_drag := 0.01
var _cannon: Rect2

onready var collision_shape := $CollisionShape2D


func _ready() -> void:
	var radius = collision_shape.shape.radius
	_cannon = Rect2(Vector2(-5, 0), Vector2(10, -radius*2))


func _physics_process(delta: float) -> void:
	_accel = face.calculate_steering(_accel)
	agent.angular_velocity += _accel.angular
	agent.angular_velocity = lerp(agent.angular_velocity, 0, _angular_drag)
	agent.orientation += agent.angular_velocity * delta
	rotation = agent.orientation


func _draw() -> void:
	draw_rect(_cannon, Color.cadetblue)


func setup(
	player_agent: GSTAgentLocation,
	align_tolerance: float,
	deceleration_radius: float,
	max_angular_accel: float,
	max_angular_speed: float
) -> void:
	face = GSTFace.new(agent, player_agent)
	
	face.alignment_tolerance = align_tolerance
	face.deceleration_radius = deceleration_radius
	
	agent.max_angular_acceleration = max_angular_accel
	agent.max_angular_speed = max_angular_speed
	agent.position = Vector3(global_position.x, global_position.y, 0)

