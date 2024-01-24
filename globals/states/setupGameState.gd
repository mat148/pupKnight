extends State

func enter():
	get_parent().get_parent().get_node("GUIManager").start_menu.visible = false
	get_parent().get_parent().get_node("GUIManager").transition.visible = true
	get_parent().get_parent().get_node("GUIManager").pause_menu.visible = false
	get_parent().get_parent().get_node("GUIManager").gameover.visible = false
	Transitioned.emit(self, "StartMenuState")
