extends Node

@export var wave :int = 1
const MAX_WAVES := 3

const SCENES := {
	"asteroids" : "uid://be3g1my4xgjv3",
	"bullet" : "uid://c0pmpn3i4eeyr",
	"debries" : "uid://dwtuv6g12fu8m",
	"player" : "uid://wps0hpecyxnr"
}

const WAVES_DATA :={
	"1" : {
		"enemies":{
			"asteroids" : 10
		},
		"stars":{
			"1": 15,
			"2": 30,
			"3": 50
		}
	},
	"2":{
		"enemies":{
			"asteroids" : 30
		},
		"stars":{
			"1": 50,
			"2": 80,
			"3": 100
		}
	},
	"3":{
		"enemies":{
			"asteroids": 50
		},
		"stars":{
			"1": 100,
			"2": 150,
			"3": 200
		}
	}
}
