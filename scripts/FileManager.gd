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
	var err = file.open(file_path, File.READ)
	assert(err == OK)
	var content = file.get_as_text()
	file.close()
	return content
	
static func folder_exist(folder:String):
	var dir = Directory.new()
	var err = dir.open(folder)
	if err != OK:
		return false
	return true
	
static func folder_empty(folder:String):
	var dir = Directory.new()
	dir.open(folder)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if not file.begins_with("."):
			if file == "":
				return true
			else:
				return false
	
static func create_folder(path:String, folder:String):
	var dir = Directory.new()
	dir.open(path)
	dir.make_dir(folder)
	
static func filesystem_init():
	if not folder_exist(Globals.USERART_SAVE_FOLDER):
		Logger.Log("Failed to locate User Folder, creating...")
		create_folder(Globals.WORKSPACE_PATH, Globals.USERARTS_FOLDER_NAME)
	if not folder_exist(Globals.PALETTES_FOLDER):
		Logger.Log("Failed to locate Palettes Folder, creating...")
		create_folder(Globals.WORKSPACE_PATH, Globals.PALETTES_FOLDER_NAME)
	if folder_empty(Globals.PALETTES_FOLDER):
		Logger.Log("Palettes Folder is empty, adding default palette...")
		var f = File.new()
		f.open(Globals.PALETTES_FOLDER + Globals.DEFAULT_PALETTE_NAME, File.WRITE)
		f.store_string(Globals.DEFAULT_PALETTE)
		f.close()
	Logger.Log("File System Initialized", LogEntry.TRIVIAL)
