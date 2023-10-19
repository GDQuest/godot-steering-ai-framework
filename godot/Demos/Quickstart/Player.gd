extends CharacterBody2D

@export var speed_max := 650.0
@export var acceleration_max := 70.0
@export var rotation_speed_max := 240
@export var rotation_accel_max := 40
@export var bullet: PackedScene

var angular_velocity := 0.0
var direction := Vector2.RIGHT

@onready var agent := GSAISteeringAgent.new()
@onready var proxy_target := GSAIAgentLocation.new()
@onready var face := GSAIFace.new(agent, proxy_target)
@onready var accel := GSAITargetAcceleration.new()
@onready var bullets := owner.get_node("Bullets")


func _ready() -> void:
	agent.linear_speed_max = speed_max
	agent.linear_acceleration_max = acceleration_max
	agent.angular_speed_max = deg_to_rad(rotation_speed_max)
	agent.angular_acceleration_max = deg_to_rad(rotation_accel_max)
	agent.bounding_radius = calculate_radius($CollisionPolygon2D.polygon)
	update_agent()

	var mouse_pos := get_global_mouse_position()
	proxy_target.position.x = mouse_pos.x
	proxy_target.position.y = mouse_pos.y

	face.alignment_tolerance = deg_to_rad(5)
	face.deceleration_radius = deg_to_rad(45)


func _physics_process(delta: float) -> void:
	update_agent()

	var movement := get_movement()

	direction = GSAIUtils.angle_to_vector2(rotation)

	velocity += direction * acceleration_max * movement * delta
	velocity = velocity.limit_length(speed_max)
	velocity = velocity.lerp(Vector2.ZERO, 0.1)
	move_and_slide()

	face.calculate_steering(accel)
	angular_velocity += accel.angular * delta
	angular_velocity = clamp(angular_velocity, -agent.angular_speed_max, agent.angular_speed_max)
	angular_velocity = lerp(angular_velocity, 0.0, 0.1)
	rotation += angular_velocity * delta


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_pos: Vector2 = event.position
		proxy_target.position.x = mouse_pos.x
		proxy_target.position.y = mouse_pos.y
	elif event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var next_bullet := bullet.instantiate()
			next_bullet.global_position = (
				global_position
				- direction * (agent.bounding_radius - 5)
			)
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


func calculate_radius(polygon: PackedVector2Array) -> float:
	var furthest_point := Vector2(-INF, -INF)
	for p in polygon:
		if abs(p.x) > furthest_point.x:
			furthest_point.x = p.x
		if abs(p.y) > furthest_point.y:
			furthest_point.y = p.y
	return furthest_point.length()
