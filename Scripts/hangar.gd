extends Control

@onready var main_menu := load(Global.SCENES.main_menu)

@onready var unlocked_ships :Dictionary = PlayerData.player_save.unlocked_ships
@onready var all_ship_data :Dictionary = Global.SHIP_TEMPLATES
@onready var ship_sprite_node := $MarginContainer/MainVBox/CenterContainer/ContentSplit/LeftPanel/ShipFrame/VBoxContainer/ShipSprite
@onready var ship_name_node := $MarginContainer/MainVBox/CenterContainer/ContentSplit/LeftPanel/ShipFrame/VBoxContainer/ShipName
@onready var ship_id_node := $MarginContainer/MainVBox/CenterContainer/ContentSplit/LeftPanel/ShipNavButtons/ShipNo
@onready var coins_node :Label= $MarginContainer/MainVBox/TopHBox/CoinBox/Amount

@onready var health_level := $MarginContainer/MainVBox/CenterContainer/ContentSplit/Rightpanel/HealthRow/StatText
@onready var health_stat := $MarginContainer/MainVBox/CenterContainer/ContentSplit/Rightpanel/HealthRow/StatValue
@onready var health_upgrade := $MarginContainer/MainVBox/CenterContainer/ContentSplit/Rightpanel/HealthRow/HUpgradeButton

@onready var damage_level := $MarginContainer/MainVBox/CenterContainer/ContentSplit/Rightpanel/DamageRow/StatText
@onready var damage_stat := $MarginContainer/MainVBox/CenterContainer/ContentSplit/Rightpanel/DamageRow/StatValue
@onready var damage_upgrade := $MarginContainer/MainVBox/CenterContainer/ContentSplit/Rightpanel/DamageRow/DUpgradeButton

@onready var speed_level := $MarginContainer/MainVBox/CenterContainer/ContentSplit/Rightpanel/SpeedRow/StatText
@onready var speed_stat := $MarginContainer/MainVBox/CenterContainer/ContentSplit/Rightpanel/SpeedRow/StatValue
@onready var speed_upgrade := $MarginContainer/MainVBox/CenterContainer/ContentSplit/Rightpanel/SpeedRow/SUpgradeButton

@onready var fire_rate_level := $MarginContainer/MainVBox/CenterContainer/ContentSplit/Rightpanel/FireRateRow/StatText
@onready var fire_rate_stat := $MarginContainer/MainVBox/CenterContainer/ContentSplit/Rightpanel/FireRateRow/StatValue
@onready var fire_rate_upgrade := $MarginContainer/MainVBox/CenterContainer/ContentSplit/Rightpanel/FireRateRow/FUpgradeButton

@onready var equip_button := $MarginContainer/MainVBox/BottomNav/EquipButton
var ship_ids :Array
var current_ship :String
var no_of_ships:int
var ship_index:int = 0

# INITIALIZATION 
func _ready() -> void:
	ship_ids = unlocked_ships.keys()
	current_ship = PlayerData.player_save.equipped_ship
	no_of_ships = ship_ids.size()
	PlayerData.render_coins(coins_node)
	render_ships()
	render_equip_button()
	render_all_stats()

# UI RENDERING 
func render_ships():
	ship_sprite_node.texture = load(all_ship_data[current_ship].sprite)
	ship_name_node.text = all_ship_data[current_ship]["name"]
	ship_id_node.text = "NO :"+current_ship
	render_all_stats()

#AI fix: Condensed duplicate stat rendering functionality to a single master function
func render_stat_ui(stat_key: String, label_node: Label, upgrade_btn: Button, stat_val_node: Label):
	var stat_data = unlocked_ships[current_ship][stat_key]
	label_node.text = stat_key.capitalize() + " :" + str(stat_data["level"])
	upgrade_btn.text = PlayerData.get_upgrade_cost(current_ship, stat_key)[0]
	max_level(stat_key, upgrade_btn, stat_val_node)

func render_all_stats():
	render_stat_ui("health", health_level, health_upgrade, health_stat)
	render_stat_ui("damage", damage_level, damage_upgrade, damage_stat)
	render_stat_ui("speed", speed_level, speed_upgrade, speed_stat)
	render_stat_ui("fire_rate", fire_rate_level, fire_rate_upgrade, fire_rate_stat)

func max_level(stat,upgrade_button,stat_text)->void:
	var current_stat = unlocked_ships[current_ship][stat]["stat"]
	if unlocked_ships[current_ship][stat]["level"] == 10:
		upgrade_button.text = "MAX"
		upgrade_button.icon = null
		PlayerData.disable_button(upgrade_button)
		stat_text.text =str(unlocked_ships[current_ship][stat]["stat"])
	else :
		upgrade_button.disabled =false
		upgrade_button.icon = load(Global.coin_sprite)
		stat_text.text = str(current_stat)+" -> "+ str(current_stat+all_ship_data[current_ship][stat]["growth"])

func render_equip_button():
	if PlayerData.player_save.equipped_ship == current_ship :
		equip_button.text = "Equipped"
		PlayerData.disable_button(equip_button)
	else:
		equip_button.text = "Equip"
		equip_button.disabled = false

# SHIP NAVIGATION
func _on_left_pressed() -> void:
	if ship_index == 0:
		current_ship = ship_ids[no_of_ships-1]
		ship_index = no_of_ships-1
	else:
		current_ship = ship_ids[(ship_index-1)%no_of_ships]
		ship_index = (ship_index-1)%no_of_ships
	render_ships()
	render_equip_button()

func _on_right_pressed() -> void:
	if ship_index == no_of_ships-1:
		current_ship = ship_ids[0]
		ship_index = 0
	else:
		current_ship = ship_ids[(ship_index+1)%no_of_ships]
		ship_index = (ship_index+1)%no_of_ships
	render_ships()
	render_equip_button()

# UPGRADE SYSTEM 

func handle_upgrade(stat_key: String, label_node: Label, upgrade_btn: Button, stat_val_node: Label):
	PlayerData.attempt_upgrade(current_ship, stat_key)
	render_stat_ui(stat_key, label_node, upgrade_btn, stat_val_node)
	PlayerData.render_coins(coins_node)

func _on_h_upgrade_button_pressed() -> void:
	handle_upgrade("health", health_level, health_upgrade, health_stat)

func _on_d_upgrade_button_pressed() -> void:
	handle_upgrade("damage", damage_level, damage_upgrade, damage_stat)

func _on_s_upgrade_button_pressed() -> void:
	handle_upgrade("speed", speed_level, speed_upgrade, speed_stat)

func _on_f_upgrade_button_pressed() -> void:
	handle_upgrade("fire_rate", fire_rate_level, fire_rate_upgrade, fire_rate_stat)

# BUTTONS 
func _on_equip_button_pressed() -> void:
	PlayerData.player_save.equipped_ship = current_ship 
	AudioManager.play_click()
	render_equip_button()

func _on_back_button_pressed() -> void:
	AudioManager.play_click()
	get_tree().change_scene_to_packed(main_menu)
