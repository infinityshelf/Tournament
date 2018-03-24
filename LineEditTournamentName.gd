extends LineEdit

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	
	self.connect("text_entered", Tournament, "set_tournament_name")
	pass

func _text_entered(text):
	#Tournament.set_tournament_name(text)
	pass
	