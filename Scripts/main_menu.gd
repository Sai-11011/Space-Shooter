extends Control

@onready var main_scene := load(Global.SCENES.main)
@onready var main_menu_scene := load(Global.SCENES.main_menu)
@onready var hanger_scene := load(Global.SCENES.hanger)
@onready var option_scene := load(Global.SCENES.options)
@onready var shop_scene := load(Global.SCENES.shop)
@onready var back_scene := load(Global.SCENES.start_ui)

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_packed(main_scene)


func _on_hanger_button_pressed() -> void:
	get_tree().change_scene_to_packed(hanger_scene)


func _on_shop_button_pressed() -> void:
	get_tree().change_scene_to_packed(shop_scene)


func _on_options_button_pressed() -> void:
	get_tree().change_scene_to_packed(option_scene)


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_packed(back_scene)
