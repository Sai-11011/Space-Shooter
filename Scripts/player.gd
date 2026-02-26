extends CharacterBody2D

@export var SPEED := 300.0
@export var health := 3
var invincible = false
var flash_tween: Tween
@onready var bullet_scene := load(Global.SCENES.bullet)
@onready var invincibility_timer = $Timers/InvincibilityTimer
@onready var  bullet_timer = $Timers/BulletTimer
@onready var bullet_start_position = $Marker2D

func process_movement() -> void :
	var direction := Input.get_vector("left", "right", "up", "down")
	velocity = direction * SPEED 
	
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

func take_damage():
	invincibility()
	health -= 1
	get_tree().root.get_node("Main").update_hearts(health)
	if health <= 0:
		get_tree().paused = true
		get_node("/root/Main/UI/MenuUI").visible = true

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
