extends Node2D

const asteroids = preload("res://Scenes/asteroids.tscn")
var rng = RandomNumberGenerator.new()
@onready var player_node = $Player

func _ready() -> void:
	pass 

func _process(_delta: float) -> void:
	pass


func _on_asteroid_timer_timeout() -> void:
	var  asteroid = asteroids.instantiate()
	asteroid.global_position = select_position()
	asteroid.look_at(player_node.position)
	get_tree().root.get_node("Main/AsteroidsContainer").add_child(asteroid)

func select_position() -> Vector2 :
	var x_spawn = rng.randf_range(0,1280)
	var y_spawn = rng.randf_range(0,720)
	if randf()>0.5:
		x_spawn = -5 if randf() > 0.5 else 1285
	else:
		y_spawn = -5 if randf() > 0.5 else 725
	return Vector2(x_spawn,y_spawn)
