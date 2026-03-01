extends Node

var coins: int = 0
var high_score: int = 0
var highest_wave: int = 1
const max_level = 10

var current_ship_id: String = "1"
var current_checkpoint := 1
var unlocked_ships: Array = ["1"] # List of ships the player owns

var settings: Dictionary = {
	"fullscreen": false,
	"master_volume": 1.0, 
	"sfx_volume": 1.0,
	"music_volume": 1.0
}

var player_save := {
	"coins": 0,
	"equipped_ship": "1",
	"unlocked_ships": {
		"1": {
			"speed_level": 0,
			"health_level": 0,
			"damage_level": 0,
			"fire_rate_level": 0
		}
	}
}
