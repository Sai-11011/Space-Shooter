extends Node

# --- 1. CURRENCY & PROGRESSION ---
var coins: int = 0
var high_score: int = 0
var highest_wave: int = 1
const max_level = 10
# --- 2. INVENTORY & UNLOCKS ---
var current_ship_id: String = "id-1" # The ship currently equipped
var unlocked_ships: Array = ["id-1"] # List of ships the player owns

# --- 3. SETTINGS ---
var settings: Dictionary = {
	"fullscreen": false,
	"master_volume": 1.0, # Range from 0.0 to 1.0
	"sfx_volume": 1.0,
	"music_volume": 1.0
}

# --- 4. THE SHIP DATABASE (What you already wrote) ---
const SHIP_STATS: Dictionary = {
	"id-1": {
		"speed": 300,
		"speed_level":1,
		"health": 5,
		"health_level":1,
		"damage": 1,
		"damage_level":1,
		"fire_rate": 0.5,
		"fire_rate_level":1,
		"sprite": "uid://d3hnkmxrkywby"
	}
}
