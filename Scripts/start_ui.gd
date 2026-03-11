extends Control

@onready var main_menu_scene := load(Global.SCENES.main_menu)
@onready var main_scene := load(Global.SCENES.main)
@onready var endless := $CenterLayout/MainVBox/MarginContainer/VBoxForButtons/EndlessButton

# INITIALIZATION 
func _ready() -> void:
	Global.check_for_endless_button(endless)

# BUTTONS 
func _on_main_menu_button_pressed() -> void:
	AudioManager.play_click()
	get_tree().change_scene_to_packed(main_menu_scene)

func _on_play_button_pressed() -> void:
	AudioManager.play_click()
	Global.endless_mode = false
	get_tree().change_scene_to_packed(main_scene)

func _on_quit_button_pressed() -> void:
	AudioManager.play_click()
	get_tree().quit()

func _on_endless_button_pressed() -> void:
	AudioManager.play_click()
	Global.endless_mode = true
	get_tree().change_scene_to_packed(main_scene)
