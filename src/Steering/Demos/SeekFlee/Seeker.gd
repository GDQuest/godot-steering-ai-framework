extends KinematicBody2D


onready var radius: = ($CollisionShape2D.shape as CircleShape2D).radius

var agent: SteeringAgent
var player_agent: AgentLocation
var seek: Seek
var accel: = TargetAcceleration.new()
var velocity: = Vector2.ZERO
var speed: float
var color: Color


func _ready() -> void:
	agent = SteeringAgent.new()
	agent.max_linear_acceleration = speed/10
	agent.max_linear_speed = speed
	
	seek = Seek.new(agent, player_agent)


func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, color)


func _physics_process(delta: float) -> void:
	_update_agent()
	accel = seek.calculate_steering(accel)
	
	velocity = (velocity + Vector2(accel.linear.x, accel.linear.y)).clamped(agent.max_linear_speed)
	velocity = move_and_slide(velocity)
	if velocity.length_squared() > 0:
		update()


func _update_agent() -> void:
	agent.position = Vector3(global_position.x, global_position.y, 0)
