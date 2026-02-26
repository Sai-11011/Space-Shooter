extends Node2D

#IMPORTS
@onready var EnemyScene :PackedScene
var rng = RandomNumberGenerator.new()
@onready var current_wave = Global.wave
@onready var max_waves = Global.MAX_WAVES
@onready var wave_data = Global.WAVES_DATA


# ALL NODES
@onready var player_node := $Player
@onready var hearts_node := $UI/GameUI/MarginContainerTop/Hearts/Label
@onready var score_node := $UI/GameUI/MarginContainerTop/Score/Label
@onready var waves_node := $UI/GameUI/MarginContainerTop/Waves/Label
@onready var enemy_timer_node := $Timers/EnemyTimer
@onready var next_wave_timer_node := $Timers/NextWave
@onready var countdown := $UI/GameUI/MarginContainerBottom/CountDown/seconds
@onready var countdown_timer_node := $Timers/CountdownTimer
@onready var countdown_node := $UI/GameUI/MarginContainerBottom/CountDown
@onready var enemies_list_node := $UI/GameUI/MarginContainerLeft/VBoxContainer/EnemiesList

#CURRENT
var score :int = 0
var current_enemies : Dictionary
var enemies_list : Array
var wave_init : bool = false
var count : int = 5

#ENEMY LOGIC
func select_position() -> Vector2 :
	var x_spawn = rng.randf_range(0,get_viewport_rect().size.x)
	var y_spawn = rng.randf_range(0,get_viewport_rect().size.y)
	if rng.randf()>0.5:
		x_spawn = -5.0 if rng.randf() > 0.5 else get_viewport_rect().size.x+5
	else:
		y_spawn = -5.0 if rng.randf() > 0.5 else get_viewport_rect().size.y+5
	return Vector2(x_spawn,y_spawn)

func prepare_wave_data():
	var wave_key = str(current_wave)
	waves_node.text = "Wave = "+wave_key
	
	if wave_data.has(wave_key) and current_wave <= max_waves:
		current_enemies = wave_data[wave_key]["enemies"].duplicate()
		enemies_list = current_enemies.keys()
		update_enemies_list()
		select_enemies_to_spawn()

func select_enemies_to_spawn():
	if enemies_list.is_empty():
		if current_wave < max_waves:
			await timer_updates()
			current_wave += 1
			wave_init = false
		return
	var enemy = enemies_list.pick_random()
	if current_enemies[enemy] <= 0:
		enemies_list.erase(enemy)
		select_enemies_to_spawn()
	else:
		current_enemies[enemy] -= 1
		spawn_enemy(enemy)

func spawn_enemy(enemy):
	if Global.SCENES.has(enemy):
		var scene_uid: String =Global.SCENES[enemy]
		var enemy_scene: PackedScene = load(scene_uid)
		var enemy_instance := enemy_scene.instantiate()
		enemy_instance.position = select_position()
		enemy_instance.look_at(player_node.global_position)
		add_child(enemy_instance)

# UI RELATED
func update_hearts(hearts:int)-> void:
	if hearts_node == null:
		return
	hearts_node.text = "X "+str(hearts)

func score_increase(s):
	score += s
	score_node.text = "Score : "+ str(score)

func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

#TIMERS
func _on_countdown_timer_timeout() -> void:
	count -= 1
	countdown.text = str(count)
	countdown_timer_node.start()

func _on_enemy_timer_timeout() -> void:
	if not wave_init :
		prepare_wave_data()
		wave_init = true
	else:
		select_enemies_to_spawn()

func timer_updates():
	next_wave_timer_node.start()
	count = 5
	countdown.text = str(count)
	countdown_node.visible = true
	countdown_timer_node.start()
	enemy_timer_node.stop()
	await next_wave_timer_node.timeout
	enemy_timer_node.start()
	countdown_timer_node.stop()
	countdown_node.visible = false

func update_enemies_list():
	enemies_list_node.text = ""
	for enemy in enemies_list:
		enemies_list_node.text += "\n"+enemy+" X"+str(current_enemies[enemy])
