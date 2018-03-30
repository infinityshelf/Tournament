extends Container

func _ready():
	pass

func _on_Button_button_up():
	Tournament.POST_start_tournament(1,1)

func _on_ButtonFinalizeTournament_button_up():
	Tournament.POST_finalize_tournament(1,1)

func _on_ButtonResetTournament_button_up():
	Tournament.POST_reset_tournament(1,1)

func _on_LineEdit_text_entered(new_text):
	Tournament.PUT_rename_tournament(var2str({"tournament":{"name":new_text}}))
