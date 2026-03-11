extends Node2D

#IMPORTS
@onready var EnemyScene :PackedScene
var rng = RandomNumberGenerator.new()
@onready var current_wave = 1
@onready var max_waves = Global.MAX_WAVES
var final_wave_spawn_complete = false
@onready var wave_data = Global.WAVES_DATA
var tween : Tween

#CURSOR
var target_cursor = preload("uid://ccpme5g6t3g1u")
var default_cursor = preload("uid://45poew1w6b2g")
@onready var main_menu := load(Global.SCENES.main_menu)
@onready var demo_end := load(Global.SCENES.demo_end)
var center_hotspot = Vector2(16, 16)
# ALL NODES

@onready var kills_node :=$UI/PauseUI/MainSplit/RightTacticalPanel/MainContent/VBoxContainer/KillsHBox/Label
@onready var orbs_node :=$UI/PauseUI/MainSplit/RightTacticalPanel/MainContent/VBoxContainer/OrbsHBox/Label
@onready var score_pause_node :=$UI/PauseUI/MainSplit/RightTacticalPanel/MainContent/VBoxContainer/ScoreHBox/Label

#UI hud
@onready var health_bar := $UI/GameUI/MarginContainerTop/HealthBar
@onready var score_node := $UI/GameUI/MarginContainerTop/Score/Label
@onready var waves_node := $UI/GameUI/MarginContainerTop/Waves/Label
@onready var coins_node := $UI/PauseUI/MainSplit/RightTacticalPanel/CoinBox/Amount
#Timers
@onready var enemy_timer_node := $Timers/EnemyTimer
@onready var next_wave_timer_node := $Timers/NextWave
@onready var countdown_timer_node := $Timers/CountdownTimer
@onready var countdown := $UI/GameUI/MarginContainerBottom/CountDown/seconds
@onready var countdown_node := $UI/GameUI/MarginContainerBottom/CountDown
@onready var freeze_timer := $Timers/FreezeTimer
#UI GameOver
@onready var player_node := $Player
@onready var camera := $Camera2D
@onready var enemies_list_node := $UI/PauseUI/MainSplit/RightTacticalPanel/TacticalVBox/EnemiesList
@onready var game_over_score := $UI/GameOverUI/CenterLayout/MainVBox/StatHBox/ScoreLabel
@onready var game_over_wave := $UI/GameOverUI/CenterLayout/MainVBox/StatHBox/WaveLabel
#UI visibles
@onready var pause_ui_node := $UI/PauseUI
@onready var gameover_ui_node := $UI/GameOverUI
@onready var enemies_container :=$EnemiesContainer
@onready var data_for_endless := $UI/PauseUI/MainSplit/RightTacticalPanel/MainContent
@onready var data_for_waves := $UI/PauseUI/MainSplit/RightTacticalPanel/TacticalVBox
#CURRENT
var score :int = 0
var current_enemies : Dictionary
var enemies_list : Array
var wave_init : bool = false
var count : int = 5
var special_enemies : Dictionary
var spawning_specials : bool = false

func _ready() -> void:
	health_bar.max_value = player_node.max_health
	health_bar.value = player_node.health
	play()
	player_node.health_change.connect(update_health_bar)
	player_node.player_died.connect(_on_player_died)
	

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if get_tree().paused:
			_on_resume_button_pressed() # Unpause if already paused
		else:
			pause()
	if final_wave_spawn_complete and enemies_container.get_child_count() == 0:
		PlayerData.player_save.score = score
		PlayerData.update_score()
		get_tree().change_scene_to_packed(demo_end)

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
	if Global.endless_mode:
		start_endless()
		return
	
	var wave_key = str(current_wave)
	waves_node.text = "Wave = " + wave_key
	
	# Reset states for the new wave
	current_enemies.clear()
	special_enemies.clear()
	enemies_list.clear()
	spawning_specials = false
	
	if wave_data.has(wave_key) and current_wave <= max_waves:
		var wave_info = wave_data[wave_key]
		
		# 1. Parse standard enemies
		if wave_info.has("enemies"):
			for enemy_type in wave_info["enemies"]:
				for variant in wave_info["enemies"][enemy_type]:
					var flat_key = enemy_type + ":" + variant
					current_enemies[flat_key] = wave_info["enemies"][enemy_type][variant]
					enemies_list.append(flat_key)
		
		# 2. Parse special phase enemies (store them for later)
		if wave_info.has("special"):
			for enemy_type in wave_info["special"]:
				for variant in wave_info["special"][enemy_type]:
					var flat_key = enemy_type + ":" + variant
					special_enemies[flat_key] = wave_info["special"][enemy_type][variant]
		
		update_enemies_list()
		select_enemies_to_spawn()

func select_enemies_to_spawn():
	if enemies_list.is_empty():
		# Check if we have special enemies waiting to spawn
		if not spawning_specials and not special_enemies.is_empty():
			spawning_specials = true
			current_enemies = special_enemies.duplicate()
			enemies_list = current_enemies.keys()
			update_enemies_list()
		else:
			# Entire wave (normal + special) is completely finished
			if current_wave < max_waves:
				await timer_updates()
				current_wave += 1
				wave_init = false
			else:
				if Global.endless_mode:
					return
				final_wave_spawn_complete = true

	if enemies_list.is_empty(): return # Safety check

	var enemy_key = enemies_list.pick_random()
	if current_enemies[enemy_key] <= 0:
		enemies_list.erase(enemy_key)
		select_enemies_to_spawn()
	else:
		current_enemies[enemy_key] -= 1
		spawn_enemy(enemy_key)

func spawn_enemy(enemy_key: String):
	# Split our flattened string back into pieces (e.g., "asteroids:elite")
	var parts = enemy_key.split(":")
	print(parts)
	var enemy_type = parts[0]
	var variant = parts[1]
	
	if Global.SCENES.has(enemy_type):
		var scene_uid: String = Global.SCENES[enemy_type]
		var enemy_scene: PackedScene = load(scene_uid)
		var enemy_instance = enemy_scene.instantiate()
		
		# Inject the stats and variant type BEFORE adding to the tree
		if enemy_instance.has_method("setup"):
			enemy_instance.setup(enemy_type, variant)
			
		enemy_instance.position = select_position()
		enemy_instance.look_at(player_node.global_position)
		enemies_container.add_child(enemy_instance)
		if Global.endless_mode:
			return
		update_enemies_list()
# UI RELATED
func update_health_bar(health:float)-> void:
	camera.apply_shake(10.0)
	get_tree().paused = true
	freeze_timer.start()
	await freeze_timer.timeout
	
	# Only unpause the game if the player is still alive!
	if health > 0:
		get_tree().paused = false
		
	if health_bar == null:
		return
	health_bar.value = player_node.health

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
	if Global.endless_mode == true:
		PlayerData.player_save.score = score
		PlayerData.update_score()
		
		get_tree().change_scene_to_packed(demo_end)
		return
		
	game_over_score.text = "SCORE : "+ str(score)
	game_over_wave.text = "WAVE : "+str(current_wave)
	gameover_ui_node.visible = true
	Global.slam_effect(gameover_ui_node)

func _on_player_died():
	get_tree().paused = true
	game_over()
	Input.set_custom_mouse_cursor(default_cursor)

func pause():
	get_tree().paused = true
	PlayerData.render_coins(coins_node)
	pause_ui_node.visible = true
	Input.set_custom_mouse_cursor(default_cursor)
	if Global.endless_mode:
		data_for_waves.hide()
		data_for_endless.show()
		PlayerData.render_run_data(score_pause_node,kills_node,orbs_node)
	else :
		data_for_endless.hide()
		data_for_waves.show()
		

#buttons
func _on_resume_button_pressed() -> void:
	AudioManager.play_click()
	pause_ui_node.visible = false
	Input.set_custom_mouse_cursor(target_cursor, Input.CURSOR_ARROW, center_hotspot)
	get_tree().paused = false

func play():
	Input.set_custom_mouse_cursor(target_cursor, Input.CURSOR_ARROW, center_hotspot)
	update_enemies_list()
	get_tree().paused = false
	enemy_timer_node.start()


func _on_restart_pressed() -> void:
	PlayerData.run_complete()
	get_tree().paused = false
	Global.instant_restart = true
	get_tree().reload_current_scene()

#TIMERS
func _on_countdown_timer_timeout() -> void:
	count -= 1
	countdown.text = str(count)
	countdown_timer_node.start()

func _on_enemy_timer_timeout() -> void:
	if Global.endless_mode :
		start_endless()
		return
	if not wave_init :
		prepare_wave_data()
		wave_init = true
	else:
		select_enemies_to_spawn()

func _on_menu_button_pressed() -> void:
	AudioManager.play_click()
	PlayerData.run_complete()
	get_tree().change_scene_to_packed(main_menu)

func start_endless():
	var enemy_to_spawn = PlayerData.endless_enemies.pick_random()
	spawn_enemy(enemy_to_spawn)
