extends Area2D

var coins_to_increase : int=1
@onready var player := get_tree().root.get_node("Main/Player")
@onready var sprite :=  $Sprite2D
var speed = 10
func _process(delta: float) -> void:
	sprite.rotation += 3*delta
	Global.follow_player_movement(self, player, speed, delta)

func _on_body_entered(_body: Node2D) -> void:
	AudioManager.play_pickup()
	PlayerData.player_save["coins"] += coins_to_increase
	queue_free()
