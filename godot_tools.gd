@tool
extends EditorPlugin

# Replace this value with a PascalCase autoload name, as per the GDScript style guide.
const AUTOLOAD_NAME = "ConsoleCommands"


func _enable_plugin():
	# The autoload can be a scene or script file.
	add_autoload_singleton(AUTOLOAD_NAME, "res://addons/godot-tools/globals/console_commands.gd")

	var plugin_addon_path = "res://addons/godot-tools/addons/console/"
	var root_addons_path = "res://addons/console/"

    # Ensure the addons directory exists in the project
	if not DirAccess.dir_exists_absolute(root_addons_path):
		DirAccess.make_dir_recursive_absolute(root_addons_path)

    # Copy contents from the plugin's directory to the root addons directory
	_copy_directory(plugin_addon_path, root_addons_path)


func _disable_plugin():
	remove_autoload_singleton(AUTOLOAD_NAME)
	
func _copy_directory(from_path: String, to_path: String) -> void:
	var dir = DirAccess.open(from_path)
	if not dir:
		return

    # Create target directory if it doesn't exist
	if not DirAccess.dir_exists_absolute(to_path):
		DirAccess.make_dir_recursive_absolute(to_path)

    # List all files and directories in the source path
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		var source = from_path + file_name
		var destination = to_path + file_name

		if dir.current_is_dir():
            # Recursively copy subdirectories
			_copy_directory(source + "/", destination + "/")
		else:
            # Copy files
			DirAccess.copy_absolute(source, destination)
		
		file_name = dir.get_next()

	dir.list_dir_end()

