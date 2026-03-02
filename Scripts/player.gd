extends CharacterBody2D

signal health_change
signal player_died

@onready var ship_no :String = PlayerData.player_save["equipped_ship"]
@onready var ship_data :Dictionary= PlayerData.player_save["unlocked_ships"][ship_no]
@onready var bullet_scene := load(Global.SCENES.bullet)
@onready var invincibility_timer := $Timers/InvincibilityTimer
@onready var  bullet_timer := $Timers/BulletTimer
@onready var bullet_start_position := $Marker2D
@onready var player_sprite := $Sprite2D
var invincible = false
var flash_tween: Tween

# Calculated Stats
var speed : float
var health : float
var damage : float
var fire_rate : float
var max_health : float
var sprite : String

func _ready() -> void:
	# 1. Load the Sprite
	sprite = ship_data.sprite
	player_sprite.texture = load(sprite)
	
	# 2. Calculate Actual Values: Base + (Growth * Level)
	speed = ship_data.speed.stat
	health = ship_data.health.stat
	damage = ship_data.damage.stat
	fire_rate = ship_data.fire_rate.stat
	
	# Set max health for UI/Healing logic later
	max_health = health
	
	# 3. Apply Fire Rate to the Timer
	bullet_timer.wait_time = fire_rate

# CURSORS
var default_cursor = preload("uid://45poew1w6b2g")

func process_movement() -> void :
	var direction := Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	
func _physics_process(_delta: float) -> void:
	process_movement()
	look_at(get_global_mouse_position())
	move_and_slide()
	if Input.is_action_pressed("shoot") and bullet_timer.is_stopped() :
		shoot()
		bullet_timer.start()

func shoot() -> void:
	var bullet = bullet_scene.instantiate()
	bullet.global_position = bullet_start_position.global_position
	bullet.global_rotation = global_rotation
	get_tree().root.get_node("Main/BulletContainer").add_child(bullet)

func take_damage(damaged_health):
	invincibility()
	health -= damaged_health
	health_change.emit(health)
	if health <= 0:
		player_died.emit()
		Input.set_custom_mouse_cursor(default_cursor)

func invincibility():
	flash_tween = create_tween()
	flash_tween.set_loops()
	modulate = Color(1.0, 0.324, 0.240, 1.0)
	flash_tween.tween_property(self,"modulate:a",0.3,0.155)
	flash_tween.tween_property(self,"modulate:a",0.6,0.155)
	set_collision_layer_value(5, false)
	invincibility_timer.start()
	invincible = true

func _on_invincibility_timer_timeout() -> void:
	set_collision_layer_value(5, true)
	flash_tween.kill()
	modulate = Color.WHITE
	invincible = false
