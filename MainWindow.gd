extends Container

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export(NodePath) var error_dialog_path
onready var error_dialog = get_node(error_dialog_path)

export(NodePath) var error_text_path
onready var error_text = get_node(error_text_path)

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	#get_node("PopupDialog").popup_centered()
	Tournament.connect("got_error_json", self, "_handle_json_error")
	#Tournament.connect("destroyed_participant_json", self, "_handle_destroyed_participant_json")
	#Tournament.connect("got_new_participant_json", self, "_handle_new_participant")
	pass
	
func _handle_json_error(json_error):
	error_dialog.popup_centered(Vector2(300,200))
	error_text.clear()
	#error_text.add_text(var2str(json_error))
	#return
	if json_error.has("response_code"):
		error_text.add_text(str(json_error["response_code"]))
		error_text.add_text("\n")
	#if json_error.has("headers"):
	#	for head in json_error["headers"]:
	#		error_text.add_text(head)
	#	
	if json_error.has("errors"):
		for error in json_error["errors"]:
			error_text.add_text(error)
			error_text.add_text("\n")

func _handle_destroyed_participant_json(json_response):
	#Tournament.GET_tournament(1,1)
	pass
	
func _handle_new_participant(json_response):
	#Tournament.GET_tournament(1,1)
	pass
	