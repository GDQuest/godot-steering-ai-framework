extends ItemList


signal demo_selected(scene_path)

var file_paths := PoolStringArray()


func _ready() -> void:
	self.connect("item_selected", self, "_on_item_selected")

	var this_directory: String = get_tree().current_scene.filename.rsplit("/", false, 1)[0]
	file_paths = _find_files(this_directory, ["*Demo.tscn"], true)
	populate(file_paths)
	select(0)


func populate(demos: PoolStringArray) -> void:
	for path in demos:
		var demo_name: String = path.rsplit("/", true, 1)[-1]
		demo_name = demo_name.rsplit("Demo", true, 1)[0]
		demo_name = sentencify(demo_name)
		add_item(demo_name)


func sentencify(line: String) -> String:
	var regex := RegEx.new()
	regex.compile("[A-Z]")
	
	line = line.split(".", true, 1)[0]
	line = regex.sub(line, " $0", true)
	return line


func _find_files(dirpath := "", patterns := PoolStringArray(), is_recursive := false, do_skip_hidden := true) -> PoolStringArray:
	var file_paths: = PoolStringArray()
	var directory: = Directory.new()

	if not directory.dir_exists(dirpath):
		printerr("The directory does not exist: %s" % dirpath)
		return file_paths
	if not directory.open(dirpath) == OK:
		printerr("Could not open the following dirpath: %s" % dirpath)
		return file_paths

	directory.list_dir_begin(true, do_skip_hidden)
	var file_name: = directory.get_next()
	var subdirectories: = PoolStringArray()
	while file_name != "":
		if directory.current_is_dir() and is_recursive:
			var subdirectory: = dirpath.plus_file(file_name)
			file_paths.append_array(_find_files(subdirectory, patterns, is_recursive))
		else:
			for pattern in patterns:
				if file_name.match(pattern):
					file_paths.append(dirpath.plus_file(file_name))
		file_name = directory.get_next()

	directory.list_dir_end()
	return file_paths


func _on_item_selected(index: int) -> void:
	var demo_path := file_paths[index]
	emit_signal("demo_selected", demo_path)
