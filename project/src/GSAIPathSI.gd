# SI = self intersecting (which needs some special handling to prevent the boids from skipping path segments)
class_name GSAIPathSI
extends GSAIPath

var segment_view_distance := 5

var _current_segment_offset := 0
var _all_segments : Array

func _init(waypoints: Array, _is_open := false, _segment_view_distance := 5).(waypoints, _is_open) -> void:
	segment_view_distance = _segment_view_distance


func create_path(waypoints: Array) -> void:
	# create segments normally
	.create_path(waypoints)
	
	# store all segments
	_all_segments = [] + _segments
	
	# only reveal the first n segments
	_activate_segments(_current_segment_offset)


func _activate_segments(skip : int):
	_segments.clear()
	
	for i in _calc_segment_range(skip):
		_segments.push_back(_all_segments[i])
	
	# TODO: update _nearest_point_on_segment / _nearest_point_on_path if needed?!


func debug_get_segment_points() -> Array:
	var points = []
	
	for segment in _segments:
		points.append(GSAIUtils.to_vector2(segment.begin))
	
	return points


func calculate_distance(agent_current_position: Vector3) -> float:
	var distance = .calculate_distance(agent_current_position)
	
	if _nearest_segment_index > segment_view_distance:
		_change_segment_offset(segment_view_distance)
	
	return distance


func _change_segment_offset(offset_delta : int):
	_current_segment_offset += offset_delta
	_activate_segments(_current_segment_offset)


func _calc_segment_range(skip : int):
	if _all_segments.size() <= (segment_view_distance * 2):
		return range(_all_segments.size())
	
	var range_to = skip + (segment_view_distance * 2)
	
	if range_to >= _all_segments.size():
		range_to = _all_segments.size()
		skip = range_to - (segment_view_distance * 2)
	
	return range(skip, range_to)
