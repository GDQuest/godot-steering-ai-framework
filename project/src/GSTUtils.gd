class_name GSTUtils
# Math and vector utility functions.


# Returns the `vector` with its length capped to `limit`.
static func clampedv3(vector: Vector3, limit: float) -> Vector3:
	var length_squared := vector.length_squared()
	var limit_squared := limit * limit
	if length_squared > limit_squared:
		vector *= sqrt(limit_squared / length_squared)
	return vector


# Returns an angle in radians between the positive X axis and the `vector`.
#
# This assumes orientation for 2D agents or 3D agents that are upright and
# rotate around the Y axis.
static func vector_to_angle(vector: Vector3) -> float:
	return atan2(vector.x, -vector.y)
