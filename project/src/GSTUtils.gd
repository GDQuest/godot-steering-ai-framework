class_name GSTUtils
# Useful math and utility functions to complement Godot's own.


static func clampedv3(vector: Vector3, limit: float) -> Vector3:
	var length_squared: = vector.length_squared()
	var limit_squared: = limit * limit
	if length_squared > limit_squared:
		vector *= sqrt(limit_squared / length_squared)
	return vector
