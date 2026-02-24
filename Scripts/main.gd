extends Node2D

const AsteroidScene = preload("res://Scenes/asteroids.tscn")
var rng = RandomNumberGenerator.new()
@onready var player_node = $Player
@onready var InvincibilityTimer = $Timers/InvincibilityTimer
var invincible = false

func _process(_delta: float) -> void:
	if invincible :
		player_node.modulate = Color(1.0, 0.460, 0.390, 0.60)
	else :
		player_node.modulate = Color(1.0, 1.0, 1.0, 1.0)
func _on_asteroid_timer_timeout() -> void:
	var  asteroid = AsteroidScene.instantiate()
	asteroid.global_position = select_position()
	asteroid.look_at(player_node.global_position)
	get_tree().root.get_node("Main/AsteroidsContainer").add_child(asteroid)

func select_position() -> Vector2 :
	var x_spawn = rng.randf_range(0,get_viewport_rect().size.x)
	var y_spawn = rng.randf_range(0,get_viewport_rect().size.y)
	if randf()>0.5:
		x_spawn = -5.0 if rng.randf() > 0.5 else get_viewport_rect().size.x+5
	else:
		y_spawn = -5.0 if rng.randf() > 0.5 else get_viewport_rect().size.y+5
	return Vector2(x_spawn,y_spawn)

func invincibility():
	player_node.set_collision_layer_value(5, false)
	InvincibilityTimer.start()
	invincible = true
	
func _on_invincibility_timer_timeout() -> void:
	player_node.set_collision_layer_value(5, true)
	invincible = false

func remove_heart():
	pass
