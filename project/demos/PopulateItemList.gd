extends ItemList


var file_paths := PoolStringArray()


func _ready() -> void:
	file_paths = _find_files("./", ["*Demo.tscn"], true)
	populate(file_paths)
	

func populate(demos: PoolStringArray) -> void:
	for demo in demos:
		var start: int = demo.find_last("/")+1
		var end: int = demo.find_last("Demo")
		var length := end - start
		var demo_name: String = demo.substr(start, length)
		demo_name = sentencify(demo_name)
		add_item(demo_name)


func sentencify(line: String) -> String:
	var word_starts := []
	for i in range(line.length()):
		var code := line.ord_at(i)
		if code < 97:
			word_starts.append(i)
	var sentence := ""
	var last := 0
	for i in range(word_starts.size()-1):
		var start: int = word_starts[i]
		last = word_starts[i+1]
		var length: = last - start
		sentence += line.substr(start, length) + " "
	sentence += line.substr(last)
	return sentence


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
