extends Button

func _ready():
	pass

func _got_participants(participants_json):
	get_node("../ItemList").add_participants(load("res://Participant.gd").parse_from_json_response(participants_json))

func _on_ButtonUpdateParticipants_button_down():
	Tournament.http_request(self, "/participants.json", funcref(self, "_got_participants"))
	pass # replace with function body
