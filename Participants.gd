extends Container

export(NodePath) var participants_item_list_path
onready var participants_item_list = get_node(participants_item_list_path)

export(NodePath) var enter_participant_dialog_path
onready var enter_participant_dialog = get_node(enter_participant_dialog_path)

export(NodePath) var enter_participant_line_edit_path
onready var enter_participant_line_edit = get_node(enter_participant_line_edit_path)

var selected_participant

func _ready():
	Tournament.connect("participants_updated", self,"_got_participants")
	pass


func _got_participants():
	participants_item_list.clear()
	var participants = Tournament.get_participants()
	if participants.size() == 0:
		return
	for p in participants:
		var participant = p["participant"]
		participants_item_list.add_item(participant["name"])

func _on_ButtonAdd_button_up():
	enter_participant_dialog.popup_centered_minsize(Vector2(200,46))


func _on_ButtonRemove_button_up():
	if selected_participant == null:
		get_node("VBoxContainer/ButtonRemove").set_enabled(false)
	else:
		Tournament.DELETE_participant(selected_participant["participant"]["id"])


func _on_ItemList_item_selected(index):
	selected_participant = Tournament.get_participants()[index]

func _on_ButtonUpdateParticipants_button_up():
	Tournament.GET_participants()

func _on_LineEditAddParticipant_text_entered(new_text):
	enter_participant_dialog.hide()
	Tournament.POST_participant(var2str({"participant":{"name":new_text}}))
	enter_participant_line_edit.clear()
