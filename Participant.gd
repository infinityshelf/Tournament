extends Object

var id = -1
var display_name = "INVALID"

func _ready():
	pass

func _init(an_id = -1, a_display_name = "INVALID"):
	id = an_id
	display_name = a_display_name
	

static func parse_from_json_response(response):
	var participants = []
	for json in response:
		var participant = json["participant"]
		participants.append(load("res://Participant.gd").new(participant["id"], participant["display_name"]))
	Tournament.set_participants(participants)
	return participants