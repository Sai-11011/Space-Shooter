extends Control

@onready var main_menu := load(Global.SCENES.main_menu)

@onready var unlocked_ships :Dictionary = PlayerData.player_save.unlocked_ships
@onready var all_ship_data :Dictionary = Global.SHIP_TEMPLATES
@onready var ship_sprite_node := $MarginContainer/MainVBox/CenterContainer/ContentSplit/LeftPanel/ShipFrame/ShipSprite
@onready var ship_name_node := $MarginContainer/MainVBox/CenterContainer/ContentSplit/LeftPanel/ShipFrame/ShipName
@onready var ship_id_node := $MarginContainer/MainVBox/CenterContainer/ContentSplit/LeftPanel/ShipNavButtons/ShipNo

#render health
@onready var health_level := $MarginContainer/MainVBox/CenterContainer/ContentSplit/Rightpanel/HealthRow/StatText
@onready var health_stat := $MarginContainer/MainVBox/CenterContainer/ContentSplit/Rightpanel/HealthRow/StatValue
@onready var health_upgrade := $MarginContainer/MainVBox/CenterContainer/ContentSplit/Rightpanel/HealthRow/UpgradeButton

@onready var damage_level := $MarginContainer/MainVBox/CenterContainer/ContentSplit/Rightpanel/DamageRow/StatText
@onready var damage_stat := $MarginContainer/MainVBox/CenterContainer/ContentSplit/Rightpanel/DamageRow/StatValue
@onready var damage_upgrade := $MarginContainer/MainVBox/CenterContainer/ContentSplit/Rightpanel/DamageRow/UpgradeButton

@onready var speed_level := $MarginContainer/MainVBox/CenterContainer/ContentSplit/Rightpanel/SpeedRow/StatText
@onready var speed_stat := $MarginContainer/MainVBox/CenterContainer/ContentSplit/Rightpanel/SpeedRow/StatValue
@onready var speed_upgrade := $MarginContainer/MainVBox/CenterContainer/ContentSplit/Rightpanel/SpeedRow/UpgradeButton

@onready var fire_rate_level := $MarginContainer/MainVBox/CenterContainer/ContentSplit/Rightpanel/FireRateRow/StatText
@onready var fire_rate_stat := $MarginContainer/MainVBox/CenterContainer/ContentSplit/Rightpanel/FireRateRow/StatValue
@onready var fire_rate_upgrade := $MarginContainer/MainVBox/CenterContainer/ContentSplit/Rightpanel/FireRateRow/UpgradeButton

var ship_ids :Array
var current_ship :String
var no_of_ships:int

func _ready() -> void:
	ship_ids = unlocked_ships.keys()
	current_ship = ship_ids[0]
	no_of_ships = ship_ids.size()
	render_ships()
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
	health_stat.text = str(health["stat"] )+" -> "+ str(health["stat"]+all_ship_data[current_ship]["health"]["growth"])
	health_upgrade.text = str(PlayerData.get_upgrade_cost(current_ship,"health"))
	
func render_damage():
	var damage = unlocked_ships[current_ship]["damage"]
	damage_level.text = "Damage :"+ str(damage["level"])
	damage_stat.text = str(damage["stat"] )+" -> "+ str(damage["stat"]+all_ship_data[current_ship]["damage"]["growth"])
	damage_upgrade.text = str(PlayerData.get_upgrade_cost(current_ship,"damage"))
	
func render_speed():
	var speed = unlocked_ships[current_ship]["speed"]
	speed_level.text = "Speed :"+ str(speed["level"])
	speed_stat.text = str(speed["stat"] )+" -> "+ str(speed["stat"]+all_ship_data[current_ship]["speed"]["growth"])
	speed_upgrade.text = str(PlayerData.get_upgrade_cost(current_ship,"speed"))
	
func render_fire_rate():
	var fire_rate = unlocked_ships[current_ship]["fire_rate"]
	fire_rate_level.text = "Fire Rate :"+ str(fire_rate["level"])
	fire_rate_stat.text = str(fire_rate["stat"] )+" -> "+ str(fire_rate["stat"]+all_ship_data[current_ship]["fire_rate"]["growth"])
	fire_rate_upgrade.text = str(PlayerData.get_upgrade_cost(current_ship,"fire_rate"))
	

func _on_left_pressed() -> void:
	if current_ship == "0":
		current_ship = ship_ids[no_of_ships-1]
	else:
		current_ship = str((int(current_ship)-1)%no_of_ships)
	render_ships()


func _on_right_pressed() -> void:
	if current_ship == ship_ids[no_of_ships-1]:
		current_ship = "0"
	else:
		current_ship = str((int(current_ship)+1)%no_of_ships)
	render_ships()
