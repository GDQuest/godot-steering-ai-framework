extends Reference
class_name GSTPath
# Represents a path made up of Vector3 waypoints, split into path segments for use by path
# following algorithms.

# # Keeping it updated requires calling `create_path` to update the path.


var open: bool
var path_length: float

var _segments: Array

var _nearest_point_on_segment: Vector3
var _nearest_point_on_path: Vector3


func _init(waypoints: Array, is_open := false) -> void:
	self.is_open = is_open
	create_path(waypoints)
	_nearest_point_on_segment = waypoints[0]
	_nearest_point_on_path = waypoints[0]


func create_path(waypoints: Array) -> void:
	if not waypoints or waypoints.size() < 2:
		printerr("Waypoints cannot be null and must contain at least two (2) waypoints.")
	
	_segments = []
	path_length = 0
	var current: Vector3 = _segments[0]
	var previous: Vector3
	
	for i in range(1, waypoints.size(), 1):
		previous = current
		if i < waypoints.size():
			current = waypoints[i]
		elif open:
			break
		else:
			current = waypoints[0]
		var segment := GSTSegment.new(previous, current)
		path_length += segment.length
		segment.cumulative_length = path_length
		_segments.append(segment)


func calculate_distance(agent_current_position: Vector3, path_parameter: Dictionary) -> float:
	var smallest_distance_squared: float = INF
	var nearest_segment: GSTSegment
	for i in range(_segments.size()):
		var segment: GSTSegment = _segments[i]
		var distance_squared := _calculate_point_segment_distance_squared(
				segment.begin,
				segment.end,
				agent_current_position)
		
		if distance_squared < smallest_distance_squared:
			_nearest_point_on_path = _nearest_point_on_segment
			smallest_distance_squared = distance_squared
			nearest_segment = segment
			path_parameter.segment_index = i
	
	var length_on_path := (
		nearest_segment.cumulative_length - 
		_nearest_point_on_path.distance_to(nearest_segment.end))
	
	path_parameter.distance = length_on_path
	
	return length_on_path


func calculate_target_position(param: Dictionary, target_distance: float) -> Vector3:
	if open:
		target_distance = clamp(target_distance, 0, path_length)
	else:
		if target_distance < 0:
			target_distance = path_length + fmod(target_distance, path_length)
		elif target_distance > path_length:
			target_distance = fmod(target_distance, path_length)
	
	var desired_segment: GSTSegment
	for i in range(_segments.size()):
		var segment: GSTSegment = _segments[i]
		if segment.cumulative_length >= target_distance:
			desired_segment = segment
			break
	
	var distance := desired_segment.cumulative_length - target_distance
	
	return (
		(desired_segment.begin - desired_segment.end) *
		(distance / desired_segment.length) + desired_segment.end)


func get_start_point() -> Vector3:
	return _segments.front().begin


func get_end_point() -> Vector3:
	return _segments.back().end


func _calculate_point_segment_distance_squared(start: Vector3, end: Vector3, position: Vector3) -> float:
	_nearest_point_on_segment = start
	var start_end := end - start
	var start_end_length_squared := start_end.length_squared()
	if start_end_length_squared != 0:
		var t = (position - start).dot(start_end) / start_end_length_squared
		_nearest_point_on_segment += start_end * clamp(t, 0, 1)
	
	return _nearest_point_on_segment.distance_squared_to(position)


class GSTSegment:
	var begin: Vector3
	var end: Vector3
	var length: float
	var cumulative_length: float
	
	
	func _init(begin: Vector3, end: Vector3) -> void:
		self.begin = begin
		self.end = end
		length = begin.distance_to(end)
