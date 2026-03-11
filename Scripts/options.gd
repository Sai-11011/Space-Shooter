extends Control

@onready var main_menu := load(Global.SCENES.main_menu)

# BUTTONS 
func _on_back_button_pressed() -> void:
	AudioManager.play_click()
	get_tree().change_scene_to_packed(main_menu)
