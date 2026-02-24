extends Area2D

@export var speed : float = 150
@export var health : int = 1
@onready var asteroid_sprite = $Sprite2D

const debries_scene := preload("res://Scenes/debries.tscn")

func _ready() -> void:
	asteroid_sprite.rotation = randi_range(0,360)

func _physics_process(delta: float) -> void:
	global_position += transform.x * speed * delta
	asteroid_sprite.rotation += 3*delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.health -= 1
		body.take_damage()
		spawn_debries()
		queue_free() 
		

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		area.queue_free()
		health-=1
		if health<=0:
			spawn_debries()
			queue_free()

func spawn_debries():
	var debries = debries_scene.instantiate()
	debries.global_position = global_position
	get_parent().add_child(debries)
