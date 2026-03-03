extends Control

@onready var coins := $MarginContainer/MainVBox/TopHBox/CoinBox/Amount
@onready var main_menu := load(Global.SCENES.main_menu)

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_packed(main_menu)

func  _ready() -> void:
	PlayerData.render_coins(coins)
