extends Control

@onready var main_menu := load(Global.SCENES.main_menu)

@onready var unlocked_ships :Dictionary = PlayerData.player_save.unlocked_ships
@onready var all_ship_data :Dictionary = Global.SHIP_TEMPLATES
@onready var ship_sprite_node := $MarginContainer/MainVBox/CenterContainer/ContentSplit/LeftPanel/ShipFrame/VBoxContainer/ShipSprite
@onready var ship_name_node := $MarginContainer/MainVBox/CenterContainer/ContentSplit/LeftPanel/ShipFrame/VBoxContainer/ShipName
@onready var ship_id_node := $MarginContainer/MainVBox/CenterContainer/ContentSplit/LeftPanel/ShipNavButtons/ShipNo
@onready var coins_node :Label= $MarginContainer/MainVBox/TopHBox/CoinBox/Amount
#render health
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

func _ready() -> void:
	ship_ids = unlocked_ships.keys()
	current_ship = PlayerData.player_save.equipped_ship
	no_of_ships = ship_ids.size()
	PlayerData.render_coins(coins_node)
	render_ships()
	render_equip_button()
	render_all_stats()

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_packed(main_menu)

func render_ships():
	ship_sprite_node.texture = load(all_ship_data[current_ship].sprite)
	ship_name_node.text = all_ship_data[current_ship]["name"]
	ship_id_node.text = "NO :"+current_ship
	render_all_stats()

func render_all_stats():
	render_health()
	render_speed()
	render_damage()
	render_fire_rate()

func render_health():
	var health = unlocked_ships[current_ship]["health"]
	health_level.text = "Health :"+ str(health["level"])
	health_upgrade.text = str(PlayerData.get_upgrade_cost(current_ship,"health"))
	max_level("health",health_upgrade,health_stat)

func render_damage():
	var damage = unlocked_ships[current_ship]["damage"]
	damage_level.text = "Damage :"+ str(damage["level"])
	damage_upgrade.text = str(PlayerData.get_upgrade_cost(current_ship,"damage"))
	max_level("damage",damage_upgrade,damage_stat)

func render_speed():
	var speed = unlocked_ships[current_ship]["speed"]
	speed_level.text = "Speed :"+ str(speed["level"])
	speed_upgrade.text = str(PlayerData.get_upgrade_cost(current_ship,"speed"))
	max_level("speed",speed_upgrade,speed_stat)

func render_fire_rate():
	var fire_rate = unlocked_ships[current_ship]["fire_rate"]
	fire_rate_level.text = "Fire Rate :"+ str(fire_rate["level"])
	fire_rate_upgrade.text = str(PlayerData.get_upgrade_cost(current_ship,"fire_rate"))
	max_level("fire_rate",fire_rate_upgrade,fire_rate_stat)

func _on_left_pressed() -> void:
	if current_ship == "0":
		current_ship = ship_ids[no_of_ships-1]
	else:
		current_ship = str((int(current_ship)-1)%no_of_ships)
	render_ships()
	render_equip_button()

func _on_right_pressed() -> void:
	if current_ship == ship_ids[no_of_ships-1]:
		current_ship = "0"
	else:
		current_ship = str((int(current_ship)+1)%no_of_ships)
	render_ships()
	render_equip_button()


func _on_h_upgrade_button_pressed() -> void:
	PlayerData.attempt_upgrade(current_ship,"health")
	render_health()
	PlayerData.render_coins(coins_node)
	max_level("health",health_upgrade,health_stat)

func _on_d_upgrade_button_pressed() -> void:
	PlayerData.attempt_upgrade(current_ship,"damage")
	render_damage()
	PlayerData.render_coins(coins_node)
	max_level("damage",damage_upgrade,damage_stat)

func _on_s_upgrade_button_pressed() -> void:
	PlayerData.attempt_upgrade(current_ship,"speed")
	render_speed()
	PlayerData.render_coins(coins_node)
	max_level("speed",speed_upgrade,speed_stat)


func _on_f_upgrade_button_pressed() -> void:
	PlayerData.attempt_upgrade(current_ship,"fire_rate")
	render_fire_rate()
	PlayerData.render_coins(coins_node)
	max_level("fire_rate",fire_rate_upgrade,fire_rate_stat)
	

func render_equip_button():
	if PlayerData.player_save.equipped_ship == current_ship :
		equip_button.text = "Equipped"
		PlayerData.disable_button(equip_button)
	else:
		equip_button.text = "Equip"
		equip_button.disabled = false

func _on_equip_button_pressed() -> void:
	PlayerData.player_save.equipped_ship = current_ship 
	render_equip_button()

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
		
