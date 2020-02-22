# Represents a path made up of Vector3 waypoints, split into segments path
# follow behaviors can use.
# category: Base types
class_name GSAIPath
extends Reference

# If `false`, the path loops.
var is_open: bool
# Total length of the path.
var length: float

var _segments: Array

var _nearest_point_on_segment: Vector3
var _nearest_point_on_path: Vector3


func _init(waypoints: Array, _is_open := false) -> void:
	self.is_open = _is_open
	create_path(waypoints)
	_nearest_point_on_segment = waypoints[0]
	_nearest_point_on_path = waypoints[0]


# Creates a path from a list of waypoints.
func create_path(waypoints: Array) -> void:
	if not waypoints or waypoints.size() < 2:
		printerr("Waypoints cannot be null and must contain at least two (2) waypoints.")
		return

	_segments = []
	length = 0
	var current: Vector3 = waypoints.front()
	var previous: Vector3

	for i in range(1, waypoints.size(), 1):
		previous = current
		if i < waypoints.size():
			current = waypoints[i]
		elif is_open:
			break
		else:
			current = waypoints[0]
		var segment := GSAISegment.new(previous, current)
		length += segment.length
		segment.cumulative_length = length
		_segments.append(segment)


# Returns the distance from `agent_current_position` to the next waypoint.
func calculate_distance(agent_current_position: Vector3) -> float:
	if _segments.size() == 0:
		return 0.0
	var smallest_distance_squared: float = INF
	var nearest_segment: GSAISegment
	for i in range(_segments.size()):
		var segment: GSAISegment = _segments[i]
		var distance_squared := _calculate_point_segment_distance_squared(
			segment.begin, segment.end, agent_current_position
		)

		if distance_squared < smallest_distance_squared:
			_nearest_point_on_path = _nearest_point_on_segment
			smallest_distance_squared = distance_squared
			nearest_segment = segment

	var length_on_path := (
		nearest_segment.cumulative_length
		- _nearest_point_on_path.distance_to(nearest_segment.end)
	)

	return length_on_path


# Calculates a target position from the path's starting point based on the `target_distance`.
func calculate_target_position(target_distance: float) -> Vector3:
	if is_open:
		target_distance = clamp(target_distance, 0, length)
	else:
		if target_distance < 0:
			target_distance = length + fmod(target_distance, length)
		elif target_distance > length:
			target_distance = fmod(target_distance, length)

	var desired_segment: GSAISegment
	for i in range(_segments.size()):
		var segment: GSAISegment = _segments[i]
		if segment.cumulative_length >= target_distance:
			desired_segment = segment
			break

	if not desired_segment:
		desired_segment = _segments.back()

	var distance := desired_segment.cumulative_length - target_distance

	return (
		((desired_segment.begin - desired_segment.end) * (distance / desired_segment.length))
		+ desired_segment.end
	)


# Returns the position of the first point on the path.
func get_start_point() -> Vector3:
	return _segments.front().begin


# Returns the position of the last point on the path.
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


class GSAISegment:
	var begin: Vector3
	var end: Vector3
	var length: float
	var cumulative_length: float

	func _init(_begin: Vector3, _end: Vector3) -> void:
		self.begin = _begin
		self.end = _end
		length = _begin.distance_to(_end)
