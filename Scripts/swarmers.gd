extends Area2D

var speed : float
var health : float
var score : float
var damage : float
var sprite_path : String
var enemy_variant : String
var coins :int
@onready var swamers_sprite = $Sprite2D
@onready var coin_scene :PackedScene= preload(Global.SCENES.coins)

#AI fix: Removed hardcoded initialization, we find it safely in _ready
@onready var player = null

# INITIALIZATION & SETUP #AI fix: Added module header
func setup(enemy_type: String, variant: String) -> void:
	var data = Global.ENEMY_DATA[enemy_type][variant]
	speed = data.speed
	health = data.health
	score = data.score
	damage = data.damage
	enemy_variant = variant
	coins = data.coins
	sprite_path = data.sprite
	if variant == "elite":
		scale = Vector2(1.3, 1.3) 
		
	if variant == "boss":
		scale = Vector2(1.6,1.6)

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	if sprite_path != "":
		swamers_sprite.texture = load(sprite_path)

# MOVEMENT
func _physics_process(delta: float) -> void:
	Global.follow_player_movement(self, player, speed, delta)

# COLLISION & COMBAT 
func _on_body_entered(body: Node2D) -> void:
	if is_queued_for_deletion(): return
	
	if body.is_in_group("player"):
		body.take_damage(damage)
		queue_free() 

func _on_area_entered(area: Area2D) -> void:
	if is_queued_for_deletion(): return 
	
	if area.is_in_group("bullet"):
		area.queue_free()
		health -= area.damage
		if health <= 0:
			#AI fix: dynamic score increase instead of hardcoded route
			if get_tree().current_scene.has_method("score_increase"):
				get_tree().current_scene.score_increase(score)
				
			PlayerData.player_save.enemies_destroyed += 1
			
			#AI fix: Consolidated probability
			var probability = 0.75 if enemy_variant == "normal" else 1.0
			if randf() < probability:
				Global.spawn_coin(global_position,coins,get_parent())
			
			queue_free()
