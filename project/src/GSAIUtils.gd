# Math and vector utility functions.
# Category: Utilities
class_name GSAIUtils

# Returns the `vector` with its length capped to `limit`.
static func clampedv3(vector: Vector3, limit: float) -> Vector3:
	var length_squared := vector.length_squared()
	var limit_squared := limit * limit
	if length_squared > limit_squared:
		vector *= sqrt(limit_squared / length_squared)
	return vector

# Returns an angle in radians between the positive X axis and the `vector`.
#
# This assumes orientation for 3D agents that are upright and rotate
# around the Y axis.
static func vector3_to_angle(vector: Vector3) -> float:
	return atan2(vector.x, vector.z)

# Returns an angle in radians between the positive X axis and the `vector`.
static func vector2_to_angle(vector: Vector2) -> float:
	return atan2(vector.x, -vector.y)

# Returns a directional vector from the given orientation angle.
# 
# This assumes orientation for 2D agents or 3D agents that are upright and
# rotate around the Y axis.
static func angle_to_vector2(angle: float) -> Vector2:
	return Vector2(sin(-angle), cos(angle))

# Returns a vector2 with `vector`'s x and y components.
static func to_vector2(vector: Vector3) -> Vector2:
	return Vector2(vector.x, vector.y)

# Returns a vector3 with `vector`'s x and y components and 0 in z.
static func to_vector3(vector: Vector2) -> Vector3:
	return Vector3(vector.x, vector.y, 0)
