extends Control

@onready var main_menu_scene := load(Global.SCENES.main_menu)
@onready var main_scene := load(Global.SCENES.main)

func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_packed(main_menu_scene)

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_packed(main_scene)

func _on_quit_button_pressed() -> void:
	get_tree().quit()
