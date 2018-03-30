extends Node

signal got_error_json
signal participants_updated
signal matches_updated
signal tournament_updated
signal match_score_updated
signal match_winner_updated

var env = {}
var api_key = "" setget set_api_key, get_api_key

var tournament = {} setget set_tournament, get_tournament
var tournament_name = "" setget set_tournament_name, get_tournament_name

func _ready():
	var file = File.new()
	if file.open("res://env.json", File.READ) == OK:
		env = JSON.parse(file.get_as_text()).result
		if env != null:
			set_api_key(env["api_key"])
			set_tournament_name(env["tournament_name"])
	file.close()
	
	GET_tournament(1,1)
	pass

# API KEY #

func set_api_key(new_key):
	api_key = new_key

func get_api_key():
	return api_key
	
# TOURNEY NAME #

func set_tournament_name(new_name):
	tournament_name = new_name
	
func get_tournament_name():
	return tournament_name
	
# TOURNAMENT #

func set_tournament(new_tournament):
	tournament = new_tournament["tournament"]
	emit_signal("tournament_updated")
	
	if tournament.has("participants"):
		emit_signal("participants_updated")
	if tournament.has("matches"):
		emit_signal("matches_updated")
		

func get_tournament():
	return tournament

# PARTICIPANTS #

func set_participants(new_participants):
	if (new_participants.has("participants")):
		tournament["participants"] = new_participants["participants"]
	else:
		tournament["participants"] = new_participants
	emit_signal("participants_updated")

func get_participants():
	return tournament["participants"]
	
func get_participant_from_id(id):
	for p in get_participants():
		var participant = p["participant"]
		if participant["id"] == id:
			return participant
	return null

func add_participant(p):
	tournament["participants"].append(p)
	emit_signal("participants_updated")
	
func removed_participant(p):
	for i in range(0, get_participants().size()):
		if (get_participants()[i]["participant"]["id"] == p["participant"]["id"]):
			get_participants().remove(i)
			emit_signal("participants_updated")
			break
	
	
# MATCHES #

func set_matches(new_matches):
	#matches = new_matches
	tournament["matches"] = new_matches
	emit_signal("matches_updated")
	
func get_matches():
	return tournament["matches"]
	
func get_match_from_id(id):
	for m_json in get_matches():
		var m = m_json["match"]
		if m["id"] == id:
			return m
	return null

func updated_match(m):
	if m["match"]["winner_id"] != null:
		emit_signal("match_winner_updated")
	emit_signal("match_score_updated")
	pass
		
# RESTFUL

func GET_tournament(include_participants=0, include_matches=0):
	_http_request(self, HTTPClient.METHOD_GET, [],".json", funcref(self, "set_tournament"), "", "&include_participants=" + str(include_participants) + "&include_matches=" + str(include_matches))

func POST_start_tournament(include_participants=0, include_matches=0):
	_http_request(self, HTTPClient.METHOD_POST, ["Content-Type: application/json"], "/start.json", funcref(self, "set_tournament"), "{}", "&include_participants=" + str(include_participants) + "&include_matches=" + str(include_matches))
	
func POST_finalize_tournament(include_participants=0, include_matches=0):
	_http_request(self,HTTPClient.METHOD_POST, ["Content-Type: application/json"], "/finalize.json", funcref(self, "set_tournament"), "{}", "&include_participants=" + str(include_participants) + "&include_matches=" + str(include_matches))
	pass
	
func POST_reset_tournament(include_participants=0, include_matches=0):
	_http_request(self, HTTPClient.METHOD_POST, ["Content-Type: application/json"], "/reset.json", funcref(self, "set_tournament"), "{}", "&include_participants=" + str(include_participants) + "&include_matches=" + str(include_matches))
	pass
	
func PUT_rename_tournament(body):
	_http_request(self, HTTPClient.METHOD_PUT, ["Content-Type: application/json"], ".json", null, body)
	
func GET_participants():
	_http_request(self, HTTPClient.METHOD_GET, [],"/participants.json", funcref(self, "set_participants"))

func POST_participant(body):
	_http_request(self, HTTPClient.METHOD_POST, ["Content-Type: application/json"], "/participants.json", funcref(self, "add_participant"), body)

func DELETE_participant(participant_id):
	_http_request(self, HTTPClient.METHOD_DELETE, [],"/participants/" + str(participant_id) + ".json", funcref(self, "removed_participant"))

func GET_matches():
	_http_request(self, HTTPClient.METHOD_GET, [],"/matches.json", funcref(self, "set_matches"))

func PUT_match(match_id, body):
	var path = "/matches/" + String(match_id) + ".json"
	_http_request(self, HTTPClient.METHOD_PUT, ["Content-Type: application/json"], path, funcref(self, "updated_match"), body)

func _http_request(sender, http_method, headers ,path, callback, body="", args=""):
	var request_url = "http://api.challonge.com/v1/tournaments/" + Tournament.get_tournament_name() + path + "?api_key=" + Tournament.get_api_key() + args
	
	var http = HTTPRequest.new()
	add_child(http)
	var error = http.request(request_url, PoolStringArray(headers), false, http_method, body)
	http.connect("request_completed", self, "_on_HTTPRequest_request_completed", [callback])
	pass
	
func _on_HTTPRequest_request_completed(result, response_code, headers, body, callback):
	var json_response = JSON.parse(body.get_string_from_ascii()).get_result()
	match response_code:
		200:
			if json_response != null and callback != null:
				callback.call_func(json_response)
		_:
			if json_response == null:
				json_response = {}
			json_response["headers"] = headers
			json_response["response_code"] = response_code
			emit_signal("got_error_json", json_response)
			for string in headers:
				print(string)
			print("********\n" + str(json_response))