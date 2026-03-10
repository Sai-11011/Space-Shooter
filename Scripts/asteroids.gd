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
# Call this from main.gd right after instantiate()
func setup(enemy_type: String, variant: String) -> void:
	var data = Global.ENEMY_DATA[enemy_type][variant]
	speed = data.speed
	health = data.health
	score = data.score
	damage = data.damage
	enemy_variant = variant
	coins = data.coins
	if variant == "elite":
		# Scaling the root node automatically scales both the sprite AND the collision shape!
		scale = Vector2(1.5, 1.5) 
		modulate = Color(1.0, 0.5, 0.5) # Optional: Tint it slightly red so players recognize the elite

func _ready() -> void:
	asteroid_sprite.rotation_degrees = randi_range(0,360)

func _physics_process(delta: float) -> void:
	global_position += transform.x * speed * delta
	asteroid_sprite.rotation += 3*delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.take_damage(damage)
		spawn_debris()
		queue_free() 

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		area.queue_free()
		health-= area.damage
		if health <= 0:
			get_tree().root.get_node("Main").score_increase(score)
			spawn_debris()
			if enemy_variant == "normal":
				if randf()<0.75:
					Global.spawn_coin(global_position,coins,get_parent())
			if enemy_variant == "elite" :
				Global.spawn_coin(global_position,coins,get_parent())
			queue_free()
		

func spawn_debris():
	var debris = debris_scene.instantiate()
	debris.global_position = global_position
	get_parent().add_child(debris)
