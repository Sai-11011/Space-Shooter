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
var max_speed : float = 80.0
var acceleration : float = 1000.0
var friction : float = 500.0
var health : float
var damage : float
var fire_rate : float
var max_health : float
var sprite : String

@onready var engine_particles := $CPUParticles2D

# CURSORS
var default_cursor = preload("uid://45poew1w6b2g")

# INITIALIZATION 
func _ready() -> void:
	sprite = ship_data.sprite
	player_sprite.texture = load(sprite)
	
	max_speed = ship_data.speed.stat
	health = ship_data.health.stat
	damage = ship_data.damage.stat
	fire_rate = ship_data.fire_rate.stat
	
	max_health = health
	
	bullet_timer.wait_time = fire_rate

# MOVEMENT & PHYSICS 
func _physics_process(delta: float) -> void:
	# MOVEMENT
	process_movement(delta)
	look_at(get_global_mouse_position())
	move_and_slide()
	
	# --- SMART ENGINE LOGIC ---
	if velocity.length() > 0:
		var forward_movement = transform.x.dot(velocity.normalized())
		
		# If the math returns > 0, you are generally moving forward
		if forward_movement > 0.2:
			engine_particles.emitting = true
			AudioManager.play_thrusters()
		else:
			AudioManager.stop_thrusters()
			engine_particles.emitting = false
	else:
		AudioManager.stop_thrusters()
		engine_particles.emitting = false

	#SHOOT
	if Input.is_action_pressed("shoot") and bullet_timer.is_stopped() :
		shoot()
		bullet_timer.start()

func process_movement(delta) -> void :
	var direction := Input.get_vector("left", "right", "up", "down")
	if direction != Vector2.ZERO:
		velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	

# COMBAT & ACTIONS 
func shoot() -> void:
	var bullet = bullet_scene.instantiate()
	bullet.damage = damage
	bullet.global_position = bullet_start_position.global_position
	bullet.global_rotation = global_rotation
	
	if get_tree().current_scene.has_node("BulletContainer"):
		get_tree().current_scene.get_node("BulletContainer").add_child(bullet)
	else:
		get_parent().add_child(bullet)

func take_damage(damaged_health):
	if invincible or health <= 0: return 
	
	invincibility()
	AudioManager.play_damage()
	health -= damaged_health
	health_change.emit(health)
	if health <= 0:
		player_died.emit()
		Input.set_custom_mouse_cursor(default_cursor)

# STATUS & TIMERS 
func invincibility():
	flash_tween = create_tween()
	flash_tween.set_loops()
	modulate = Color(1.0, 0.324, 0.240, 1.0)
	flash_tween.tween_property(self,"modulate:a",0.3,0.155)
	flash_tween.tween_property(self,"modulate:a",0.6,0.155)
	set_collision_layer_value(5, false)
	set_collision_layer_value(4, true)
	invincibility_timer.start()
	invincible = true

func _on_invincibility_timer_timeout() -> void:
	set_collision_layer_value(5, true)
	set_collision_layer_value(4, false)
	flash_tween.kill()
	modulate = Color.WHITE
	invincible = false
