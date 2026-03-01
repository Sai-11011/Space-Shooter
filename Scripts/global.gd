extends Node

const MAX_WAVES := 3
var instant_restart := false

const SCENES := {
	"asteroids" : "uid://be3g1my4xgjv3",
	"bullet" : "uid://c0pmpn3i4eeyr",
	"debries" : "uid://dwtuv6g12fu8m",
	"hanger" : "uid://cs08l7k75auvx",
	"main" : "uid://cx2pqbupj44x2",
	"main_menu" : "uid://c4sfrp1apvpjs",
	"player" : "uid://wps0hpecyxnr",
	"start_ui":"uid://bfhhy2axnjpom",
	"shop":"uid://dgytnrptoqh6y",
	"options":"uid://c630bxhkysr62"
}

const WAVES_DATA :={
	"1" : {
		"enemies":{
			"asteroids" : 15
		},
	},
	"2":{
		"enemies":{
			"asteroids" : 20
		},
	},
	"3":{
		"enemies":{
			"asteroids": 30
		}
	}
}

const ENEMY_DATA := {
	"asteroid":{
		"health":1,
		"score":1,
		"damage":1,
		"speed":150
	},#scene not created yet after creating i will add them in waves accordingly
	"swarmers":{
		"health":1,
		"score":3,
		"damage":1,
		"speed":100
	},
	"elite_swarmers":{
		"health":3,
		"score":5,
		"damage":2,
		"speed":150
	}
}

const SHIP_TEMPLATES := {
	"1": {
		"name": "THE ROOKIE",              
		"sprite": "uid://d3hnkmxrkywby",   
		"speed": {
			"start": 300,
			"max": 500,
			"growth": 20,
			"base_cost": 50,
			"cost_mult": 1.5              
		},
		"health": {
			"start": 3.0,
			"max": 8.0,
			"growth": 0.5,
			"base_cost": 100,
			"cost_mult": 1.5
		},
		"damage": {
			"start": 1.0,
			"max": 6.0,
			"growth": 0.5,
			"base_cost": 150,
			"cost_mult": 1.8               
		},
		"fire_rate": {
			"start": 0.5,
			"max": 0.15,
			"growth": -0.035,
			"base_cost": 150,
			"cost_mult": 1.8
		}
	}
}


func slam_effect(slam):
	var tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(slam, "scale", Vector2(1, 1), 0.5)\
	.set_trans(Tween.TRANS_BACK)\
	.set_ease(Tween.EASE_OUT)\
	.from(Vector2(3, 3))
