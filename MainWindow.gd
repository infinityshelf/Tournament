extends Container

export(NodePath) var error_dialog_path
onready var error_dialog = get_node(error_dialog_path)

export(NodePath) var error_text_path
onready var error_text = get_node(error_text_path)

func _ready():
	Tournament.connect("got_error_json", self, "_handle_json_error")
	
func _handle_json_error(json_error):
	error_dialog.popup_centered(Vector2(300,200))
	error_text.clear()
	
	if json_error.has("response_code"):
		error_text.add_text(str(json_error["response_code"]))
		error_text.add_text("\n")
		
	if json_error.has("errors"):
		for error in json_error["errors"]:
			error_text.add_text(error)
			error_text.add_text("\n")	