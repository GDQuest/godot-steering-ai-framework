extends KinematicBody2D


var face: GSTFace
var agent := GSTKinematicBody2DAgent.new(self)

var _accel := GSTTargetAcceleration.new()
var _angular_drag := 0.1
var _cannon: Rect2
var _color: Color

onready var collision_shape := $CollisionShape2D


func _ready() -> void:
	var radius = collision_shape.shape.radius
	_cannon = Rect2(Vector2(-5, 0), Vector2(10, -radius*2))
	_color = collision_shape.outer_color


func _physics_process(delta: float) -> void:
	face.calculate_steering(_accel)
	agent.apply_steering(_accel, delta)


func _draw() -> void:
	draw_rect(_cannon, _color)


func setup(
	player_agent: GSTAgentLocation,
	align_tolerance: float,
	deceleration_radius: float,
	angular_accel_max: float,
	angular_speed_max: float
) -> void:
	face = GSTFace.new(agent, player_agent)
	
	face.alignment_tolerance = align_tolerance
	face.deceleration_radius = deceleration_radius
	
	agent.angular_acceleration_max = angular_accel_max
	agent.angular_speed_max = angular_speed_max
	agent.angular_drag_percentage = _angular_drag
