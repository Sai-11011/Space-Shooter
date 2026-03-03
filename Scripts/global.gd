extends Node

const MAX_WAVES := 3
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
		"normal":{
			"health":0.5,
			"score":1.0,
			"damage":0.5,
			"speed":100
		},
		"elite":{
			"health":1.5,
			"score":1.5,
			"damage":1.0,
			"speed":150
		}
	},#scene not created yet after creating i will add them in waves accordingly
	"swarmers":{
		"normal":{
			"health":1,
			"score":3,
			"damage":1,
			"speed":100
		},
		"elite":{
			"health":1,
			"score":3,
			"damage":1,
			"speed":100
		},
		"boss":{
			"health":1,
			"score":3,
			"damage":1,
			"speed":100
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
	},
	"1": {
		"name": "THE PULSAR",
		"sprite": "uid://bgv6cuicbe5nh",
		"description": "A direct, high-tech upgrade over the Nomad. It offers heavier armor plating and experimental twin-core thrusters for an equilibrium of speed and offensive capability.",
		"speed": {
			"start": 350,
			"max": 550,
			"growth": 20,
			"base_cost": 75,
			"cost_mult": 1.6
		},
		"health": {
			"start": 4.0,
			"max": 9.0,
			"growth": 0.5,
			"base_cost": 120,
			"cost_mult": 1.6
		},
		"damage": {
			"start": 1.5,
			"max": 7.0,
			"growth": 0.5,
			"base_cost": 180,
			"cost_mult": 1.9
		},
		"fire_rate": {
			"start": 0.45,
			"max": 0.10,
			"growth": -0.035,
			"base_cost": 180,
			"cost_mult": 1.9
		}
	},
	"2": {
		"name": "THE VECTOR",
		"sprite": "uid://dxs0hug3rioq7",
		"description": "Prioritizes maximum thrust and agility over structural integrity. Its aerodynamic chassis allows for lightning-fast evasive maneuvers.",
		"speed": {
			"start": 400,
			"max": 700,
			"growth": 30,
			"base_cost": 100,
			"cost_mult": 1.7
		},
		"health": {
			"start": 2.0,
			"max": 5.0,
			"growth": 0.3,
			"base_cost": 80,
			"cost_mult": 1.4
		},
		"damage": {
			"start": 1.0,
			"max": 5.0,
			"growth": 0.4,
			"base_cost": 150,
			"cost_mult": 1.8
		},
		"fire_rate": {
			"start": 0.35,
			"max": 0.08,
			"growth": -0.027,
			"base_cost": 200,
			"cost_mult": 2.0
		}
	},
	"3": {
		"name": "THE JUGGERNAUT",
		"sprite": "uid://d2i4gru0c5lw7",
		"description": "A hulking fortress of reinforced steel and sheer firepower. It suffers heavily in mobility but makes up for it with a massive health pool and devastating heavy cannons.",
		"speed": {
			"start": 200,
			"max": 350,
			"growth": 15,
			"base_cost": 50,
			"cost_mult": 1.4
		},
		"health": {
			"start": 6.0,
			"max": 15.0,
			"growth": 1.0,
			"base_cost": 200,
			"cost_mult": 2.0
		},
		"damage": {
			"start": 3.0,
			"max": 10.0,
			"growth": 0.7,
			"base_cost": 250,
			"cost_mult": 2.2
		},
		"fire_rate": {
			"start": 0.7,
			"max": 0.3,
			"growth": -0.04,
			"base_cost": 120,
			"cost_mult": 1.5
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
