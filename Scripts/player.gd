extends CharacterBody2D

const SPEED := 300.0

const bullet_scene := preload("res://Scenes/bullet.tscn")

func process_movement() -> void :
	var direction := Input.get_vector("left", "right", "up", "down")
	velocity = direction * SPEED 
	
func _physics_process(_delta: float) -> void:
	process_movement()
	look_at(get_global_mouse_position())
	move_and_slide()
	if Input.is_action_pressed("shoot") and $Timers/BulletTimer.is_stopped() :
		shoot()
		$Timers/BulletTimer.start()

func shoot() -> void:
	var bullet = bullet_scene.instantiate()
	bullet.global_position=global_position
	bullet.global_rotation=global_rotation
	get_parent().add_child(bullet)
	
