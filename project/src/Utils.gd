class_name Utils


static func clmapedv3(vector: Vector3, limit: float) -> Vector3:
	var len2: = vector.length_squared()
	var limit2: = limit * limit
	if len2 > limit2:
		vector *= sqrt(limit2 / len2)
	return vector
