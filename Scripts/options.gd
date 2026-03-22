extends Control

@onready var main_menu := load(Global.SCENES.main_menu)

@onready var master_node := $MarginContainer/VBoxContainer/CenterContainer/SettingsGrid/MasterSlider
@onready var music_node := $MarginContainer/VBoxContainer/CenterContainer/SettingsGrid/MusicSlider
@onready var sfx_node := $MarginContainer/VBoxContainer/CenterContainer/SettingsGrid/SFXSlider
@onready var full_screen_node := $MarginContainer/VBoxContainer/CenterContainer/SettingsGrid/CheckButton

func _ready() -> void:
	master_node.value = PlayerData.settings.master_volume
	music_node.value = PlayerData.settings.music_volume
	sfx_node.value = PlayerData.settings.sfx_volume
	full_screen_node.button_pressed = PlayerData.settings.fullscreen 

# BUTTONS 
func _on_back_button_pressed() -> void:
	AudioManager.play_click()
	get_tree().change_scene_to_packed(main_menu)

func _on_check_button_toggled(toggled_on: bool) -> void:
	PlayerData.settings.fullscreen = toggled_on
	
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_master_slider_value_changed(value: float) -> void:
	var bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	AudioServer.set_bus_mute(bus_index, value < 0.01)
	PlayerData.settings.master_volume = value


func _on_music_slider_value_changed(value: float) -> void:
	var bus_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	AudioServer.set_bus_mute(bus_index, value < 0.01)
	PlayerData.settings.music_volume = value


func _on_sfx_slider_value_changed(value: float) -> void:
	var bus_index = AudioServer.get_bus_index("Sfx")
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	AudioServer.set_bus_mute(bus_index, value < 0.01)
	PlayerData.settings.sfx_volume = value
