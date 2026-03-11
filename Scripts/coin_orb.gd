extends Area2D

var coins_to_increase : int=1

@onready var player = null
@onready var sprite :=  $Sprite2D
var speed = 1000

# INITIALIZATION 
func _ready():
	player = get_tree().get_first_node_in_group("player")

# BEHAVIOR & PHYSICS 
func _process(delta: float) -> void:
	sprite.rotation += 3*delta
	if is_instance_valid(player):
		global_position = global_position.move_toward(player.global_position, speed * delta)

# COLLISIONS & SIGNALS 
func _on_body_entered(_body: Node2D) -> void:
	if is_queued_for_deletion(): return 
	AudioManager.play_pickup()
	PlayerData.player_save["current_run_coins"] += coins_to_increase
	queue_free()
