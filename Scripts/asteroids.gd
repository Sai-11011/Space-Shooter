extends Area2D

@onready var asteroid_sprite = $Sprite2D
@onready var coin_scene = load(Global.SCENES.coins)
@onready var debris_scene:= load(Global.SCENES.debris)
var enemy_variant :String
var speed : float
var health : float
var score : float
var damage : float
var coins :int
@onready var player = get_tree().get_first_node_in_group("player")

# INITIALIZATION 

func setup(enemy_type: String, variant: String) -> void:
	var data = Global.ENEMY_DATA[enemy_type][variant]
	speed = data.speed
	health = data.health
	score = data.score
	damage = data.damage
	enemy_variant = variant
	coins = data.coins
	if variant == "elite":
		scale = Vector2(1.5, 1.5) 
		modulate = Color(1.0, 0.5, 0.5) 

func _ready() -> void:
	asteroid_sprite.rotation_degrees = randi_range(0,360)

# MOVEMENT 
func _physics_process(delta: float) -> void:
	global_position += transform.x * speed * delta
	asteroid_sprite.rotation += 3*delta

# COLLISION & COMBAT
func _on_body_entered(body: Node2D) -> void:
	if is_queued_for_deletion(): return #Check if already dead to prevent multiple damage instances
	
	if body.is_in_group("player"):
		body.take_damage(damage)
		spawn_debris()
		queue_free() 

func _on_area_entered(area: Area2D) -> void:
	if is_queued_for_deletion(): return #Prevent processing if already queued for deletion
	
	if area.is_in_group("bullet"):
		area.queue_free()
		health-= area.damage
		if health <= 0:
			if get_tree().current_scene.has_method("score_increase"):
				get_tree().current_scene.score_increase(score)
			
			spawn_debris()
			PlayerData.player_save.enemies_destroyed += 1
			
			#Consolidated probability check to spawn coin
			var spawn_chance = 0.25 if enemy_variant == "normal" else 0.5
			if randf() < spawn_chance:
				Global.spawn_coin(global_position,coins,get_parent())
			
			queue_free()

# DEATH & CLEANUP
func spawn_debris():
	var debris = debris_scene.instantiate()
	debris.global_position = global_position
	get_parent().add_child(debris)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
