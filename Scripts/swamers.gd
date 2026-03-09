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
@onready var player = get_tree().root.get_node("Main/Player")

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
	# Find the player once when the enemy is created using Godot's group system
	player = get_tree().get_first_node_in_group("player")
	if sprite_path != "":
		swamers_sprite.texture = load(sprite_path)

func _physics_process(delta: float) -> void:
	Global.follow_player_movement(self, player, speed, delta)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.take_damage(damage)
		queue_free() 

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		area.queue_free()
		health -= area.damage
		
		if health <= 0:
			get_tree().root.get_node("Main").score_increase(score)
			var coins_instance = coin_scene.instantiate()
			coins_instance.coins_to_increase = coins
			coins_instance.global_position = global_position
			coins_instance.look_at(player.position)
			if enemy_variant == "normal":
				if randf()<0.75:
					get_parent().call_deferred("add_child", coins_instance)
			if enemy_variant == "elite" or enemy_variant == "boss":
				get_parent().call_deferred("add_child", coins_instance)
			queue_free()
