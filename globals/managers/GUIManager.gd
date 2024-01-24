extends Node2D

@export var start_menu: Control
@export var transition: Control
@export var pause_menu: Control
@export var gameover: Control

func _ready():
	SignalManager.start_GUI.connect(start_GUI)
	SignalManager.transition_in.connect(fade_in)
	SignalManager.transition_out.connect(fade_out)
	SignalManager.pause_GUI.connect(toggle_pause_menu)
	SignalManager.gameover_GUI.connect(gameover_menu)

func fade_in():
	transition.get_node("AnimationPlayer").play("fade_in")

func fade_out():
	transition.get_node("AnimationPlayer").play("fade_out")

func start_GUI():
	start_menu.visible = !start_menu.visible

func toggle_pause_menu():
	pause_menu.visible = !pause_menu.visible

func gameover_menu():
	gameover.visible = !gameover.visible
