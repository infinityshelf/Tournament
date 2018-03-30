extends Container

#onready var matches = []

var selected_match setget set_match,get_match

export(NodePath) var matches_button_path
export(NodePath) var player_1_tag_path
export(NodePath) var player_2_tag_path
export(NodePath) var score_label_path

onready var player_1_tag = get_node(player_1_tag_path)
onready var player_2_tag = get_node(player_2_tag_path)
onready var score_label = get_node(score_label_path)
onready var matches_button = get_node(matches_button_path)

onready var scores = [0,0]

#onready var p1_tag_file = File.new()#.open("p1_tag.txt", File.WRITE)
#onready var p2_tag_file = File.new()#.open("p2_tag.txt", File.WRITE)

func _ready():
	matches_button.clear()
	matches_button.add_item("Click \"Update\" to get matches ->")
	player_1_tag.set_text("")
	player_2_tag.set_text("")
	Tournament.connect("matches_updated", self, "_on_matches_updated")
	Tournament.connect("match_score_updated", self, "_on_match_score_updated")
	Tournament.connect("match_winner_updated", self, "_on_match_winner_updated")

func _on_matches_updated():

	matches_button.clear()
	matches_button.add_item("Select a match ...")
	
	for m in Tournament.get_matches():
		var p1_id = m["match"]["player1_id"]
		var p2_id = m["match"]["player2_id"]
			
		var p1 = Tournament.get_participant_from_id(p1_id)
		var p2 = Tournament.get_participant_from_id(p2_id)
		
		var p1tag = "???"
		var p2tag = "???"
		
		if (p1 != null):
			p1tag = p1.display_name
		elif (p1_id != null):
			p1tag = "p1 id: " + str(p1_id)
		
		if (p2 != null):
			p2tag = p2.display_name
		elif (p2_id != null):
			p2tag = "p2 id: " + str(p2_id)
		
		var match_round = "INVALID"
		if (m["match"]["round"] != null):
			match_round = m["match"]["round"]
			match_round = match_round_from_int(m["match"]["round"])
		
		matches_button.add_item(match_round + " " + p1tag + " vs " + p2tag)
		if (m["match"]["state"] == "pending"):
			matches_button.set_item_disabled(matches_button.get_item_count()-1, true)
	pass
	
func match_round_from_int(match_round):
	if (match_round > 0):
		return "W" + String(abs(match_round))
	else:
		return "L" + String(abs(match_round))
	

func _on_ButtonUpdateMatches_button_up():
	_clear_tags()
	Tournament.GET_matches()

func _clear_tags():
	player_1_tag.set_text("")
	player_2_tag.set_text("")
	score_label.set_text("---")
	selected_match = null
	matches_button.select(0)
	

func _on_OptionButtonMatches_item_selected(ID):
	set_match(Tournament.get_matches()[ID-1]) # + 1 for placeholder row
	pass # replace with function body

func set_match(new_match):
	selected_match = new_match
	
	player_1_tag.set_text(Tournament.get_participant_from_id(selected_match["match"]["player1_id"]).display_name)
	player_2_tag.set_text(Tournament.get_participant_from_id(selected_match["match"]["player2_id"]).display_name)
	
	if selected_match["match"]["scores_csv"] == "":
		scores = [0,0]
	else:
		scores = selected_match["match"]["scores_csv"].split("-")
		scores = [scores[0].to_int(), scores[1].to_int()]
	score_label.set_text(String(scores[0]) + "-" + String(scores[1]))
	updated_match()
	pass
	
func updated_match():
	var p1_tag_file = File.new()
	var p2_tag_file = File.new()
	var p1_score_file = File.new()
	var p2_score_file = File.new()
	
	p1_tag_file.open("p1_tag.txt", File.WRITE)
	p2_tag_file.open("p2_tag.txt", File.WRITE)
	p1_score_file.open("p1_score.txt", File.WRITE)
	p2_score_file.open("p2_score.txt", File.WRITE)
		
	p1_tag_file.store_string(player_1_tag.get_text())
	p2_tag_file.store_string(player_2_tag.get_text())
	p1_score_file.store_string(str(scores[0]))
	p2_score_file.store_string(str(scores[1]))
	
	p1_tag_file.close()
	p2_tag_file.close()
	p1_score_file.close()
	p2_score_file.close()
	pass
	
func get_match():
	return selected_match

func _on_ButtonSwapLabels_button_up():
	pass # replace with function body


func _on_ButtonP1AddPoint_button_up():
	scores[0] += 1
	score_label.set_text(String(scores[0]) + "-" + String(scores[1]))
	update_match_score()
	pass

func _on_ButtonP1RemovePoint_button_up():
	scores[0] -= 1
	score_label.set_text(String(scores[0]) + "-" + String(scores[1]))
	update_match_score()
	pass # replace with function body


func _on_ButtonP2AddPoint_button_up():
	scores[1] += 1
	score_label.set_text(String(scores[0]) + "-" + String(scores[1]))
	update_match_score()
	pass # replace with function body


func _on_ButtonP2RemovePoint_button_up():
	scores[1] -= 1
	score_label.set_text(String(scores[0]) + "-" + String(scores[1]))
	update_match_score()
	pass # replace with function body

func update_match_score():
	updated_match()
	if selected_match == null:
		return
	var body = {
		"match": {
			"scores_csv":score_label.get_text()
		}
	}
	Tournament.PUT_match(selected_match["match"]["id"], var2str(body))
	
func update_match_winner(winner_id):
	updated_match()
	if selected_match == null:
		return
	var body = {
		"match": {
			"scores_csv":score_label.get_text(),
			"winner_id": str(winner_id)
		}
	}
	Tournament.PUT_match(selected_match["match"]["id"], var2str(body))

func _on_ButtonP1Winner_button_up():
	update_match_winner(selected_match["match"]["player1_id"])
	pass # replace with function body
	

func _on_ButtonP2Winner_button_up():
	update_match_winner(selected_match["match"]["player2_id"])
	pass # replace with function body

func _on_match_winner_updated():
	_clear_tags()
	Tournament.GET_matches()
	pass
	
func _on_match_score_updated():
	pass