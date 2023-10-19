extends ItemList

signal demo_selected(scene_path)

var file_paths := PackedStringArray()


func _ready() -> void:
	# warning-ignore:return_value_discarded
	self.connect("item_selected", Callable(self, "_on_item_selected"))
	
	var this_directory: String = get_tree().current_scene.scene_file_path.rsplit("/", false, 1)[0]
	file_paths = _find_files(this_directory, ["*Demo.tscn"], true)
	populate(file_paths)
	select(0)


func populate(demos: PackedStringArray) -> void:
	for path in demos:
		var demo_name: String = path.rsplit("/", true, 1)[-1]
		demo_name = demo_name.rsplit("Demo", true, 1)[0]
		demo_name = sentencify(demo_name)
		add_item(demo_name)


func sentencify(line: String) -> String:
	var regex := RegEx.new()
	# warning-ignore:return_value_discarded
	regex.compile("[A-Z]")

	line = line.split(".", true, 1)[0]
	line = regex.sub(line, " $0", true)
	return line


func _find_files(
	dirpath := "", patterns := PackedStringArray(), is_recursive := false, _do_skip_hidden := true
) -> PackedStringArray:
	var paths := PackedStringArray()
	var directory := DirAccess.open(dirpath)

	if not directory.dir_exists(dirpath):
		printerr("The directory does not exist: %s" % dirpath)
		return paths
	if directory == null:
		printerr("Could not open the following dirpath: %s" % dirpath)
		return paths

	# warning-ignore:return_value_discarded
	directory.list_dir_begin() # TODOConverter3To4 fill missing arguments https://github.com/godotengine/godot/pull/40547
	var file_name := directory.get_next()
	while file_name != "":
		if directory.current_is_dir() and is_recursive:
			var subdirectory := dirpath.path_join(file_name)
			paths.append_array(_find_files(subdirectory, patterns, is_recursive))
		else:
			for pattern in patterns:
				if file_name.match(pattern):
					paths.append(dirpath.path_join(file_name))
		file_name = directory.get_next()

	directory.list_dir_end()
	return paths


func _on_item_selected(index: int) -> void:
	var demo_path := file_paths[index]
	emit_signal("demo_selected", demo_path)
