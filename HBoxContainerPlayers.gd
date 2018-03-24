extends HBoxContainer

func _ready():
	get_node("OptionButtonMatches").clear()

func got_matches(matches):
	var option1 = get_node("OptionButtonMatches")
	for m in matches:
		var p1 = Tournament.get_participant(m["match"]["player1_id"]).display_name
		var p2 = Tournament.get_participant(m["match"]["player2_id"]).display_name
		option1.add_item(String(m["match"]["round"]) + " " + p1 + " vs " + p2)
	pass

func _on_ButtonUpdateMatches_button_up():
	Tournament.http_request(self, "/matches.json", funcref(self, "got_matches"))
