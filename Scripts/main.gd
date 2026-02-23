extends Node2D

const asteroids = preload("res://Scenes/asteroids.tscn")
var rng = RandomNumberGenerator.new()
@onready var player_node = $Player

func _on_asteroid_timer_timeout() -> void:
	var  asteroid = asteroids.instantiate()
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
