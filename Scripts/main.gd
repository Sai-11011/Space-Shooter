extends Node2D

#IMPORTS
@onready var EnemyScene :PackedScene
var rng = RandomNumberGenerator.new()
@onready var current_wave = 1
@onready var max_waves = Global.MAX_WAVES
@onready var wave_data = Global.WAVES_DATA
var tween : Tween

#CURSOR
var target_cursor = preload("uid://ccpme5g6t3g1u")
var default_cursor = preload("uid://45poew1w6b2g")
var center_hotspot = Vector2(16, 16)
# ALL NODES

#UI hud
@onready var hearts_node := $UI/GameUI/MarginContainerTop/Hearts/Label
@onready var score_node := $UI/GameUI/MarginContainerTop/Score/Label
@onready var waves_node := $UI/GameUI/MarginContainerTop/Waves/Label
#Timers
@onready var enemy_timer_node := $Timers/EnemyTimer
@onready var next_wave_timer_node := $Timers/NextWave
@onready var countdown_timer_node := $Timers/CountdownTimer
@onready var countdown := $UI/GameUI/MarginContainerBottom/CountDown/seconds
@onready var countdown_node := $UI/GameUI/MarginContainerBottom/CountDown
#UI GameOver
@onready var player_node := $Player
@onready var enemies_list_node := $UI/PauseUI/MainSplit/RightTacticalPanel/TacticalVBox/EnemiesList
@onready var game_over_score := $UI/GameOverUI/CenterLayout/MainVBox/StatHBox/ScoreLabel
@onready var game_over_wave := $UI/GameOverUI/CenterLayout/MainVBox/StatHBox/WaveLabel
#UI visibles
@onready var game_over_container := $UI/GameOverUI/CenterLayout
@onready var pause_ui_node := $UI/PauseUI
@onready var start_ui_node := $UI/StartUI
@onready var gameover_ui_node := $UI/GameOverUI
#CURRENT
var score :int = 0
var current_enemies : Dictionary
var enemies_list : Array
var wave_init : bool = false
var count : int = 5

func _ready() -> void:
	update_hearts(player_node.health)
	if Global.instant_restart:
		start_ui_node.visible = false
		play()
	else:
		get_tree().paused = true
		enemy_timer_node.stop()
	player_node.health_change.connect(update_hearts)
	player_node.player_died.connect(_on_player_died)
	

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if get_tree().paused:
			_on_resume_button_pressed() # Unpause if already paused
		else:
			pause()

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
		update_enemies_list()

# UI RELATED
func update_hearts(hearts:int)-> void:
	if hearts_node == null:
		return
	hearts_node.text = "X "+str(hearts)

func score_increase(s):
	score += s
	score_node.text = "Score : "+ str(score)

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
		enemies_list_node.text += " - "+enemy+" X"+str(current_enemies[enemy])+"\n"

func game_over():
	game_over_score.text = "SCORE : "+ str(score)
	game_over_wave.text = "WAVE : "+str(current_wave)
	gameover_ui_node.visible = true
	Global.slam_effect(game_over_container)

func _on_player_died():
	get_tree().paused = true
	game_over()
	Input.set_custom_mouse_cursor(default_cursor)

func pause():
	get_tree().paused = true
	pause_ui_node.visible = true
	Input.set_custom_mouse_cursor(default_cursor)

func _on_resume_button_pressed() -> void:
	pause_ui_node.visible = false
	Input.set_custom_mouse_cursor(target_cursor, Input.CURSOR_ARROW, center_hotspot)
	get_tree().paused = false

func play():
	Input.set_custom_mouse_cursor(target_cursor, Input.CURSOR_ARROW, center_hotspot)
	update_enemies_list()
	get_tree().paused = false
	enemy_timer_node.start()

func _on_play_button_pressed() -> void:
	start_ui_node.visible = false
	play()


func _on_restart_pressed() -> void:
	get_tree().paused = false
	Global.instant_restart = true
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
