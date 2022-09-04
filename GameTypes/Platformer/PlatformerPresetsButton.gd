extends OptionButton

signal preset_loaded(data)

func dir_contents(path):
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				pass
			else:
				add_item(file_name.split('.')[0])
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

func _ready():
	dir_contents("res://Resources/platformer_presets/")
	connect("item_selected", self, "_on_item_selected")
	
func _on_item_selected(index):
	var filename = get_item_text(index)
	var data = load("res://Resources/platformer_presets/" + filename + ".tres")
	if data is PlatformerData:
		emit_signal("preset_loaded", data)

