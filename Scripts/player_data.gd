extends Node

const MAX_LEVEL = 10

var high_score: int = 0
var highest_wave: int = 1
var current_checkpoint: int = 1

var settings: Dictionary = {
	"fullscreen": false,
	"master_volume": 1.0, 
	"sfx_volume": 1.0,
	"music_volume": 1.0
}

# The Save File: Only stores currency, equipped items, and integer levels.
var player_save := {
	"coins": 1000,
	"equipped_ship": "0",
	"unlocked_ships":{
		"0": {
			"sprite": Global.SHIP_TEMPLATES["0"]["sprite"],
			"speed":{
				"level":0,
				"stat":Global.SHIP_TEMPLATES["0"].speed.start,
			},
			"health":{
				"level":0,
				"stat":Global.SHIP_TEMPLATES["0"].health.start,
			},
			"damage": {
				"level":0,
				"stat":Global.SHIP_TEMPLATES["0"].damage.start,
			},
			"fire_rate":{ 
				"level":0,
				"stat":Global.SHIP_TEMPLATES["0"].fire_rate.start,
			}
		},
	}
}


func get_upgrade_cost(ship_id: String, stat_name: String) -> int:
	var template = Global.SHIP_TEMPLATES[ship_id][stat_name]
	var current_level = player_save.unlocked_ships[ship_id][stat_name]["level"]
	
	if current_level >= MAX_LEVEL:
		return -1 
		
	var cost = template.base_cost * pow(template.cost_mult, current_level)
	
	return int(cost)

func attempt_upgrade(ship_id: String, stat_name: String) -> bool:
	var current_level = player_save.unlocked_ships[ship_id][stat_name]["level"]
	
	if current_level >= MAX_LEVEL:
		print("Already at max level!")
		return false
		
	var cost = get_upgrade_cost(ship_id, stat_name)

	if player_save.coins >= cost:
		player_save.coins -= cost
		player_save.unlocked_ships[ship_id][stat_name]["level"] += 1
		AudioManager.play_upgrade()
		print("Upgrade successful! Level is now: ", player_save.unlocked_ships[ship_id][stat_name]["level"])
		player_save.unlocked_ships[ship_id][stat_name]["stat"] += Global.SHIP_TEMPLATES[ship_id][stat_name].growth
		return true
	else:
		AudioManager.play_click()
		print("Not enough coins!")
		return false
		

func render_coins(coins_node) -> void:
	coins_node.text = format_coins(player_save.coins)

func format_coins(amount: int) -> String:
	if amount >= 1_000_000:
		# Format to 1 decimal place, then remove ".0" if it's a clean number
		var formatted = "%.1f" % (amount / 1_000_000.0)
		return formatted.trim_suffix(".0") + "M"
	elif amount >= 1_000:
		var formatted = "%.1f" % (amount / 1_000.0)
		return formatted.trim_suffix(".0") + "K"
	else:
		return str(amount)

func disable_button(button_node) -> void:
	button_node.disabled = true
	button_node.focus_mode = Control.FOCUS_NONE
	if button_node.has_focus():
		button_node.release_focus()
