extends ItemList

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export(bool) var get_participants_on_load

func _ready():
	pass

func add_participants(participants):
	clear()
	for p in participants:
		add_item(p.display_name)
