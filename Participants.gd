extends Container

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export(NodePath) var match_container_path
onready var match_container = get_node(match_container_path)

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	Tournament.http_request(self, HTTPClient.METHOD_GET, [],"/participants.json", funcref(self, "_got_participants"))
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _got_participants(participants_json):
	get_node("VBoxContainer/ItemList").add_participants(load("res://Participant.gd").parse_from_json_response(participants_json))
	#Tournament.http_request(self, HTTPClient.METHOD_GET, [], "/matches.json", funcref(match_container, "got_matches"))
