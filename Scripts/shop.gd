extends Control

@onready var coins := $MarginContainer/MainVBox/TopHBox/CoinBox/Amount
@onready var main_menu := load(Global.SCENES.main_menu)
@onready var ship_button1 := $MarginContainer/MainVBox/MainSplit/ScrollContainer/GridContainer/ShipButton1
@onready var ship_button2 := $MarginContainer/MainVBox/MainSplit/ScrollContainer/GridContainer/ShipButton2
@onready var ship_button3 := $MarginContainer/MainVBox/MainSplit/ScrollContainer/GridContainer/ShipButton3

@onready var current_item := "1"
var current_price := 0
const  all_items := Global.SHIP_TEMPLATES
@onready var sprite := $MarginContainer/MainVBox/MainSplit/ShowcasePanel/HBoxContainer/PreviewFrame
@onready var item_name := $MarginContainer/MainVBox/MainSplit/ShowcasePanel/HBoxContainer/VBoxContainer/ItemName
@onready var item_description := $MarginContainer/MainVBox/MainSplit/ShowcasePanel/HBoxContainer/VBoxContainer/ItemDescription
@onready var buy_button := $MarginContainer/MainVBox/MainSplit/ShowcasePanel/HBoxContainer/VBoxContainer/MarginContainer/BuyButton

func _on_back_button_pressed() -> void:
	AudioManager.play_click()
	get_tree().change_scene_to_packed(main_menu)

func  _ready() -> void:
	PlayerData.render_coins(coins)
	render_spaceships()

func render_spaceships():
	sprite.texture = load(all_items[current_item]["sprite"])
	item_name.text = all_items[current_item]["name"]
	item_description.text = all_items[current_item]["description"]
	current_price = all_items[current_item]["coins"]
	if PlayerData.player_save["unlocked_ships"].has(current_item):
		buy_button.disabled = true
		buy_button.text = "BOUGHT"
		buy_button.icon = null
	else :
		buy_button.disabled = false
		buy_button.text = PlayerData.format_coins(current_price)

func _on_ship_button_1_pressed() -> void:
	current_item = "1"
	AudioManager.play_click()
	render_spaceships()

func _on_ship_button_2_pressed() -> void:
	current_item = "2"
	AudioManager.play_click()
	render_spaceships()

func _on_ship_button_3_pressed() -> void:
	current_item = "3"
	AudioManager.play_click()
	render_spaceships()

func _on_buy_button_pressed() -> void:
	if PlayerData.player_save["coins"] >= all_items[current_item]["coins"]:
		buy()
		AudioManager.play_upgrade()
	else:
		AudioManager.play_click()

func buy():
	PlayerData.player_save["coins"] -= current_price
	PlayerData.render_coins(coins)
	PlayerData.player_save["unlocked_ships"][current_item] = {
		"sprite": Global.SHIP_TEMPLATES[current_item]["sprite"],
		"speed":{
			"level":0,
			"stat":Global.SHIP_TEMPLATES[current_item].speed.start,
		},
		"health":{
			"level":0,
			"stat":Global.SHIP_TEMPLATES[current_item].health.start,
		},
		"damage": {
			"level":0,
			"stat":Global.SHIP_TEMPLATES[current_item].damage.start,
		},
		"fire_rate":{ 
			"level":0,
			"stat":Global.SHIP_TEMPLATES[current_item].fire_rate.start,
		}
	}
	render_spaceships()
	
