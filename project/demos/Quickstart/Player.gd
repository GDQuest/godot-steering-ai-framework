extends KinematicBody2D


export var maximum_speed := 650.0 # Maximum possible linear velocity
export var maximum_acceleration := 70.0 # Maximum change in linear velocity
export var maximum_rotation_speed := 240 # Maximum rotation velocity represented in degrees
export var maximum_rotation_accel := 40 # Maximum change in rotation velocity represented in degrees
export var bullet: PackedScene

var velocity := Vector2.ZERO
var angular_velocity := 0.0
var bullet_cache := []
var direction := Vector2.RIGHT

onready var agent := GSTSteeringAgent.new()
onready var proxy_target := GSTAgentLocation.new()
onready var face := GSTFace.new(agent, proxy_target)
onready var accel := GSTTargetAcceleration.new()
onready var bullets := owner.get_node("Bullets")


func _ready() -> void:
	agent.max_linear_speed = maximum_speed
	agent.max_linear_acceleration = maximum_acceleration
	agent.max_angular_speed = deg2rad(maximum_rotation_speed)
	agent.max_angular_acceleration = deg2rad(maximum_rotation_accel)
	agent.bounding_radius = calculate_radius($CollisionPolygon2D.polygon)
	update_agent()
	
	var mouse_pos := get_global_mouse_position()
	proxy_target.position.x = mouse_pos.x
	proxy_target.position.y = mouse_pos.y
	
	face.alignment_tolerance = deg2rad(5)
	face.deceleration_radius = deg2rad(45)


func _physics_process(delta: float) -> void:
	update_agent()
	
	var movement := get_movement()
	
	direction = Vector2(sin(-rotation), cos(rotation))
	
	velocity += direction * maximum_acceleration * movement
	velocity = velocity.clamped(maximum_speed)
	velocity = velocity.linear_interpolate(Vector2.ZERO, 0.1)
	velocity = move_and_slide(velocity)
	
	face.calculate_steering(accel)
	angular_velocity += accel.angular
	angular_velocity = clamp(angular_velocity, -agent.max_angular_speed, agent.max_angular_speed)
	angular_velocity = lerp(angular_velocity, 0, 0.1)
	rotation += angular_velocity * delta


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_pos: Vector2 = event.position
		proxy_target.position.x = mouse_pos.x
		proxy_target.position.y = mouse_pos.y
	elif event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			var next_bullet: = bullet.instance()
			next_bullet.global_position = global_position - direction * (agent.bounding_radius-5)
			next_bullet.player = self
			next_bullet.start(-direction)
			bullets.add_child(next_bullet)

func get_movement() -> float:
	return Input.get_action_strength("sf_down") - Input.get_action_strength("sf_up")


func update_agent() -> void:
	agent.position.x = global_position.x
	agent.position.y = global_position.y
	agent.orientation = rotation
	agent.linear_velocity.x = velocity.x
	agent.linear_velocity.y = velocity.y
	agent.angular_velocity = angular_velocity


func calculate_radius(polygon: PoolVector2Array) -> float:
	var furthest_point := Vector2(-INF, -INF)
	for p in polygon:
		if abs(p.x) > furthest_point.x:
			furthest_point.x = p.x
		if abs(p.y) > furthest_point.y:
			furthest_point.y = p.y
	return furthest_point.length()
