extends Control

@onready var main_scene := load(Global.SCENES.main)
@onready var main_menu_scene := load(Global.SCENES.main_menu)
@onready var hangar_scene := load(Global.SCENES.hangar)
@onready var option_scene := load(Global.SCENES.options)
@onready var shop_scene := load(Global.SCENES.shop)
@onready var back_scene := load(Global.SCENES.start_ui)

@onready var coins = $MarginContainer/TopHBox/CoinBox/Amount
@onready var endless = $MarginContainer/CenterMenu/MainButtons/EndlessButton

# INITIALIZATION 
func _ready() -> void:
	PlayerData.render_coins(coins)

# BUTTONS 
func _on_play_button_pressed() -> void:
	AudioManager.play_click()
	Global.endless_mode = false
	get_tree().change_scene_to_packed(main_scene)

func _on_shop_button_pressed() -> void:
	AudioManager.play_click()
	get_tree().change_scene_to_packed(shop_scene)

func _on_options_button_pressed() -> void:
	AudioManager.play_click()
	get_tree().change_scene_to_packed(option_scene)

func _on_back_button_pressed() -> void:
	AudioManager.play_click()
	get_tree().change_scene_to_packed(back_scene)

func _on_hanger_button_pressed() -> void:
	AudioManager.play_click()
	get_tree().change_scene_to_packed(hangar_scene)

func _on_endless_button_pressed() -> void:
	AudioManager.play_click()
	Global.endless_mode = true
	get_tree().change_scene_to_packed(main_scene)
