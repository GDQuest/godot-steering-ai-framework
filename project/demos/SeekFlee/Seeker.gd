extends KinematicBody2D
# AI agent that uses the Seek behavior to hone in on the player's location as directly as possible.


var player_agent: GSTAgentLocation
var velocity := Vector2.ZERO
var start_speed: float
var start_accel: float
var use_seek := true

onready var agent := GSTSteeringAgent.new()
onready var accel := GSTTargetAcceleration.new()
onready var seek := GSTSeek.new(agent, player_agent)
onready var flee := GSTFlee.new(agent, player_agent)


func _ready() -> void:
	agent.linear_acceleration_max = start_accel
	agent.linear_speed_max = start_speed


func _physics_process(delta: float) -> void:
	if not player_agent:
		return
	
	_update_agent()
	if use_seek:
		accel = seek.calculate_steering(accel)
	else:
		accel = flee.calculate_steering(accel)
	
	velocity = (velocity + Vector2(accel.linear.x, accel.linear.y)).clamped(agent.linear_speed_max)
	velocity = move_and_slide(velocity)


func _update_agent() -> void:
	agent.position.x = global_position.x
	agent.position.y = global_position.y
	agent.linear_velocity.x = velocity.x
	agent.linear_velocity.y = velocity.y
