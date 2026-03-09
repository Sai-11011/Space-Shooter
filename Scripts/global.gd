extends Node

const MAX_WAVES := 5
var instant_restart := false
var coin_sprite := "uid://x6norgv5bcn4"

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
	"options":"uid://c630bxhkysr62",
	"swamers":"uid://mr0m4apc7yrv"
}

const WAVES_DATA :={
	"1" : {
		"enemies":{
			"asteroids" : {
				"normal":10
			}
		},
	},
	"2":{
		"enemies":{
			"asteroids" : {
				"normal":15
			}
		},
	},
	"3":{
		"enemies":{
			"asteroids": {
				"normal" : 25,
			}
		},
		"special":{
			"asteroids": {
				"elite":1
			}
		}
	},
	"4":{
		"enemies":{
			"asteroids":{
				"normal" : 25,
			},
			"swamers":{
				"elite":1
			}
		}
	},
	"5":{
		"enemies":{
			"swamers":{
				"normal" : 25,
			}
		},
		"special":{
			"swamers":{
				"Boss":1
			}
		}
	}
}

const ENEMY_DATA := {
	"asteroids":{
		"normal":{
			"sprite":"uid://clo1hb3w8ek3u",
			"health":5.0,
			"score":1.0,
			"damage":3.0,
			"speed":100
		},
		"elite":{
			"sprite":"uid://b3usk7aefnw8c",
			"health":15.0,
			"score":2.0,
			"damage":6.0,
			"speed":80
		}
	},#scene not created yet after creating i will add them in waves accordingly
	"swamers":{
		"normal":{
			"sprite":"uid://bp1273m0mthun",
			"health":10.0,
			"score":2,
			"damage":8.0,
			"speed":100
		},
		"elite":{
			"sprite":"uid://b2pyk4o812wty",
			"health":10.0,
			"score":3,
			"damage":10.0,
			"speed":130
		},
		"boss":{
			"sprite":"uid://ce1nw71c7mmmo",
			"health":25.0,
			"score":5,
			"damage":15.0,
			"speed":80
		}
	},
}

const SHIP_TEMPLATES := {
	"0": {
		"name": "THE NOMAD",
		"sprite": "uid://bofh4faap5uls",
		"description": "A reliable, mass-produced chassis. It doesn't excel in any one category, but its perfectly balanced core makes it a highly dependable vessel.",
		"speed": {
			"start": 300,
			"growth": 20,
			"base_cost": 50,
			"cost_mult": 1.5
		},
		"health": {
			"start": 30.0,
			"growth": 5.0,
			"base_cost": 100,
			"cost_mult": 1.5
		},
		"damage": {
			"start": 10.0,
			"growth": 5.0,
			"base_cost": 150,
			"cost_mult": 1.8
		},
		"fire_rate": {
			"start": 0.5,
			"growth": -0.035,
			"base_cost": 150,
			"cost_mult": 1.8
		}
	},
	"1": {
		"name": "THE PULSAR",
		"coins":500,
		"sprite": "uid://bgv6cuicbe5nh",
		"description": "A direct, high-tech upgrade over the Nomad. It offers heavier armor plating and experimental twin-core thrusters for an equilibrium of speed and offensive capability.",
		"speed": {
			"start": 350,
			"growth": 20,
			"base_cost": 75,
			"cost_mult": 1.6
		},
		"health": {
			"start": 40.0,
			"growth": 5.0,
			"base_cost": 120,
			"cost_mult": 1.6
		},
		"damage": {
			"start": 15.0,
			"growth": 5.0,
			"base_cost": 180,
			"cost_mult": 1.9
		},
		"fire_rate": {
			"start": 0.45,
			"growth": -0.035,
			"base_cost": 180,
			"cost_mult": 1.9
		}
	},
	"2": {
		"name": "THE VECTOR",
		"coins":1000,
		"sprite": "uid://dxs0hug3rioq7",
		"description": "Prioritizes maximum thrust and agility over structural integrity. Its aerodynamic chassis allows for lightning-fast evasive maneuvers.",
		"speed": {
			"start": 400,
			"growth": 30,
			"base_cost": 100,
			"cost_mult": 1.7
		},
		"health": {
			"start": 20.0,
			"growth": 3.0,
			"base_cost": 80,
			"cost_mult": 1.4
		},
		"damage": {
			"start": 12.0,
			"growth": 4.0,
			"base_cost": 150,
			"cost_mult": 1.8
		},
		"fire_rate": {
			"start": 0.35,
			"growth": -0.027,
			"base_cost": 200,
			"cost_mult": 2.0
		}
	},
	"3": {
		"name": "THE JUGGERNAUT",
		"coins":3000,
		"sprite": "uid://d2i4gru0c5lw7",
		"description": "A hulking fortress of reinforced steel and sheer firepower. It suffers heavily in mobility but makes up for it with a massive health pool and devastating heavy cannons.",
		"speed": {
			"start": 200,
			"growth": 15,
			"base_cost": 50,
			"cost_mult": 1.4
		},
		"health": {
			"start": 60.0,
			"growth": 10.0,
			"base_cost": 200,
			"cost_mult": 2.0
		},
		"damage": {
			"start": 30.0,
			"growth": 7.0,
			"base_cost": 250,
			"cost_mult": 2.1
		},
		"fire_rate": {
			"start": 0.6,
			"growth": -0.04,
			"base_cost": 120,
			"cost_mult": 1.6
		}
	}
}

var SHOP := { 
	"ship_ids" : ["1","2","3"]
}

func slam_effect(slam):
	var tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(slam, "scale", Vector2(1, 1), 0.5)\
	.set_trans(Tween.TRANS_BACK)\
	.set_ease(Tween.EASE_OUT)\
	.from(Vector2(3, 3))
