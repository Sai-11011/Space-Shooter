extends Area2D

var speed : float
var health : float
var score : float
var damage : float
var sprite_path : String
@onready var swamers_sprite = $Sprite2D
# Store the player reference
var player: Node2D

func setup(enemy_type: String, variant: String) -> void:
	var data = Global.ENEMY_DATA[enemy_type][variant]
	speed = data.speed
	health = data.health
	score = data.score
	damage = data.damage
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
	if is_instance_valid(player):
		# 1. Base direction toward player
		var direction_to_player = (player.global_position - global_position).normalized()
		var separation = Vector2.ZERO
		
		# 2. Check for overlapping friends
		for area in get_overlapping_areas():
			if area.is_in_group("enemy") and area != self:
				var push_vector = global_position - area.global_position
				if push_vector.length() > 0: # Prevent math errors
					# Push harder the closer they are
					separation += push_vector.normalized() / push_vector.length()
					
		# 3. Combine directions (Tweaked the multiplier for better balance)
		var final_direction = (direction_to_player + (separation * 15.0)).normalized()
		
		# --- THE SMOOTH ROTATION FIX ---
		# Find the angle we WANT to face
		var target_angle = final_direction.angle()
		# Smoothly turn from our current rotation to the target rotation
		rotation = lerp_angle(rotation, target_angle, 10.0 * delta)
		
	# Move forward in the direction we are currently facing
	global_position += transform.x * speed * delta

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
			queue_free()
