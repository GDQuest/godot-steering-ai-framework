class_name Utils
"""
Useful math and utility functions to complement Godot's own.
"""


static func clmapedv3(vector: Vector3, limit: float) -> Vector3:
	var len2: = vector.length_squared()
	var limit2: = limit * limit
	if len2 > limit2:
		vector *= sqrt(limit2 / len2)
	return vector
