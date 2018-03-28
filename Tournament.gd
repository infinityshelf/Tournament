extends Node

signal got_participants
signal got_matches
signal error

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var http = get_node("ParticipantsHTTPRequest")

var env = {}
var api_key = "" setget set_api_key, get_api_key
var participants = [] setget set_participants,get_participants
var tournament_name = "godot" setget set_tournament_name, get_tournament_name

func _ready():
	var file = File.new()
	file.open("res://env.json", File.READ)
	env = JSON.parse(file.get_as_text()).result
	
	api_key = env["api_key"]
	file.close()
	
	#HTTPClient.new().connect_to_host("https://api.challonge.com/v1/", 80, false, true)
	pass

func set_api_key(new_key):
	api_key = new_key

func get_api_key():
	return api_key
	
func set_tournament_name(new_name):
	tournament_name = new_name
	
func get_tournament_name():
	return tournament_name

func set_participants(new_participants):
	participants = new_participants

func get_participants():
	return participants
	
func get_participant(id):
	for p in participants:
		if p.id == id:
			return p
	return null

func http_request(sender, http_method, headers ,path, method, body=""):
	var request_url = "http://api.challonge.com/v1/tournaments/" + Tournament.get_tournament_name() + path + "?api_key=" + Tournament.get_api_key()
	http.request(request_url, PoolStringArray(headers), false, http_method, body)
	#http.request(http_method, request_url, headers, body)
	http.connect("request_completed", self, "_on_HTTPRequest_request_completed", [method], CONNECT_ONESHOT)
	pass
	
func _on_HTTPRequest_request_completed(result, response_code, headers, body, callback):
	var json_response = JSON.parse(body.get_string_from_ascii()).get_result()
	match response_code:
		200:
			callback.call_func(json_response)
		_:
			emit_signal("error", json_response)
			for string in headers:
				print(string)
			print("********\n" + str(JSON.parse(body.get_string_from_ascii()).get_result()))