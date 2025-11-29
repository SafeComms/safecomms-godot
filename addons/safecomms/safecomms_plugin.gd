@tool
extends EditorPlugin

func _enter_tree():
	# Add the SafeComms singleton to the project's Autoloads
	add_autoload_singleton("SafeComms", "res://addons/safecomms/SafeComms.gd")

func _exit_tree():
	# Remove the singleton when the plugin is disabled
	remove_autoload_singleton("SafeComms")
