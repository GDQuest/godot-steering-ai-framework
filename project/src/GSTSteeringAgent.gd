extends GSTAgentLocation
class_name GSTSteeringAgent
# Extended agent data type that adds velocity, speed, and size data


var zero_linear_speed_threshold := 0.01
var linear_speed_max := 0.0
var linear_acceleration_max := 0.0
var angular_speed_max := 0.0
var angular_acceleration_max := 0.0
var linear_velocity := Vector3.ZERO
var angular_velocity := 0.0
var bounding_radius := 0.0
var tagged := false
