extends Control

@onready var main_menu_scene := load(Global.SCENES.main_menu)
@onready var score_node := $MarginContainer/VBoxContainer/MainContent/VBoxContainer/ScoreHBox/Label
@onready var kills_node := $MarginContainer/VBoxContainer/MainContent/VBoxContainer/KillsHBox/Label
@onready var orbs_node := $MarginContainer/VBoxContainer/MainContent/VBoxContainer/OrbsHBox/Label
var default_cursor = preload("uid://45poew1w6b2g")
@onready var main_scene := load(Global.SCENES.main)

func _ready() -> void:
	Input.set_custom_mouse_cursor(default_cursor)
	Global.endless_unlocked = true
	PlayerData.render_run_data(score_node,kills_node,orbs_node)
	


func _on_menu_button_pressed() -> void:
	AudioManager.play_click()
	get_tree().change_scene_to_packed(main_menu_scene)

func _on_endless_button_pressed() -> void:
	Global.endless_mode = true
	get_tree().change_scene_to_packed(main_scene)


func _on_wishlist_button_pressed() -> void:
	pass # Replace with function body.
