extends Node

const MAX_WAVES := 3

var instant_restart := false


const SCENES := {
	"asteroids" : "uid://be3g1my4xgjv3",
	"bullet" : "uid://c0pmpn3i4eeyr",
	"debries" : "uid://dwtuv6g12fu8m",
	"player" : "uid://wps0hpecyxnr",
	"main": "uid://cx2pqbupj44x2"
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

const PLAYER_DATA :={
	"1":{#i will change before releasing the demo and make them practical stats
		"speed":300,
		"max_speed":500,
		"health":5,
		"max_health":10,
		"damage":1,
		"max_damage":5,
		"sprite":"uid://d3hnkmxrkywby",
	},#expand for future ships after demo
}

func slam_effect(slam):
	var tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(slam, "scale", Vector2(1, 1), 0.5)\
	.set_trans(Tween.TRANS_BACK)\
	.set_ease(Tween.EASE_OUT)\
	.from(Vector2(3, 3))
