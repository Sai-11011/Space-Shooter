extends Node

# INITIALIZATION 
func _ready() -> void:
	play_bgm()

# AUDIO PLAYBACK FUNCTIONS
func play_bullet():
	$LaserBullet.play()

func play_click():
	$Click.play()

func play_pickup():
	$Pickup.play()

func play_damage():
	$Damage.play()

func play_thrusters():
	$Thrusters.play()

func stop_thrusters():
	$Thrusters.stop()

func play_upgrade():
	$Upgrade.play()

func play_bgm():
	if not $BGM.playing:
		$BGM.play()
