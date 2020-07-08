extends Object
class_name FileManager

static func list_files_in_directory(path:String):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		#跳过隐藏文件
		elif not file.begins_with("."):
			files.append(file)
	dir.list_dir_end()
	
	return files

static func directory_has_file(fname:String, path:String) -> bool:
	var files = list_files_in_directory(path)
	if fname in files:
		return true
	return false

static func read_file_string(file_path:String):
	var file = File.new()
	file.open(file_path, File.READ)
	var content = file.get_as_text()
	file.close()
	return content
