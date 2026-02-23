extends Area2D

var speed = 150
var health = 1

func _process(delta: float) -> void:
	global_position += transform.x * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		queue_free() #player taking damage logic should be implementad

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		area.queue_free()
		health-=1
		if health<=0:
			queue_free()
