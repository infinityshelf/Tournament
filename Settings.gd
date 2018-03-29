extends Container

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export(NodePath) var tournament_name_line_edit_path
export(NodePath) var api_key_line_edit_path

onready var tournament_name_line_edit= get_node(tournament_name_line_edit_path)
onready var api_key_line_edit = get_node(api_key_line_edit_path)

func _ready():
	tournament_name_line_edit.set_text(Tournament.get_tournament_name())
	api_key_line_edit.set_text(Tournament.get_api_key())

func _on_LineEditTournamentName_text_entered(new_text):
	Tournament.GET_tournament()

func _on_LineEditApiKey_text_entered(new_text):
	Tournament.GET_tournament()
