extends Reference
class_name GSTPath


var segments: Array
var is_open: bool
var path_length: float

var nearest_point_on_segment: Vector3
var nearest_point_on_path: Vector3


func _init(waypoints: Array, is_open: = false) -> void:
	self.is_open = is_open
	_create_path(waypoints)
	nearest_point_on_segment = waypoints[0]
	nearest_point_on_path = waypoints[0]


func get_start_point() -> Vector3:
	return segments.front().begin


func get_end_point() -> Vector3:
	return segments.back().end


func calculate_point_segment_distance_squared(a: Vector3, b: Vector3, c: Vector3) -> float:
	nearest_point_on_segment = a
	var ab: = b - a
	var ab_length_squared: = ab.length_squared()
	if ab_length_squared != 0:
		var t = (c - a).dot(ab) / ab_length_squared
		nearest_point_on_segment += ab * clamp(t, 0, 1)
	
	return nearest_point_on_segment.distance_squared_to(c)


func calculate_distance(agent_current_position: Vector3, path_parameter: Dictionary) -> float:
	var smallest_distance_squared: float = INF
	var nearest_segment: GSTSegment
	for i in range(segments.size()):
		var segment: GSTSegment = segments[i]
		var distance_squared: = calculate_point_segment_distance_squared(
				segment.begin,
				segment.end,
				agent_current_position)
		
		if distance_squared < smallest_distance_squared:
			nearest_point_on_path = nearest_point_on_segment
			smallest_distance_squared = distance_squared
			nearest_segment = segment
			path_parameter.segment_index = i
	
	var length_on_path: = (
		nearest_segment.cumulative_length - 
		nearest_point_on_path.distance_to(nearest_segment.end))
	
	path_parameter.distance = length_on_path
	
	return length_on_path


func calculate_target_position(param: Dictionary, target_distance: float) -> Vector3:
	if is_open:
		target_distance = clamp(target_distance, 0, path_length)
	else:
		if target_distance < 0:
			target_distance = path_length + fmod(target_distance, path_length)
		elif target_distance > path_length:
			target_distance = fmod(target_distance, path_length)
	
	var desired_segment: GSTSegment
	for i in range(segments.size()):
		var segment: GSTSegment = segments[i]
		if segment.cumulative_length >= target_distance:
			desired_segment = segment
			break
	
	var distance: = desired_segment.cumulative_length - target_distance
	
	return (
		(desired_segment.begin - desired_segment.end) *
		(distance / desired_segment.length) + desired_segment.end)


func _create_path(waypoints: Array) -> void:
	if not waypoints or waypoints.size() < 2:
		printerr("Waypoints cannot be null and must contain at least two (2) waypoints.")
	
	segments = []
	path_length = 0
	var current: Vector3 = segments[0]
	var previous: Vector3
	
	for i in range(1, waypoints.size(), 1):
		previous = current
		if i < waypoints.size():
			current = waypoints[i]
		elif is_open:
			break
		else:
			current = waypoints[0]
		var segment: = GSTSegment.new(previous, current)
		path_length += segment.length
		segment.cumulative_length = path_length
		segments.append(segment)


class GSTSegment:
	var begin: Vector3
	var end: Vector3
	var length: float
	var cumulative_length: float
	
	
	func _init(begin: Vector3, end: Vector3) -> void:
		self.begin = begin
		self.end = end
		length = begin.distance_to(end)
