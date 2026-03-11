extends Camera2D

var decay: float = 0.8  
var shake_strength: float = 0.0  
var base_offset: Vector2 

# INITIALIZATION 
func _ready() -> void:
	offset = Vector2(640, 360)
	base_offset = offset 

# BEHAVIOR & PHYSICS 
func _process(delta):
	# Using 0.1 instead of 0 prevents the camera from doing microscopic shakes forever
	if shake_strength > 0.1:
		var random_x = randf_range(-shake_strength, shake_strength)
		var random_y = randf_range(-shake_strength, shake_strength)
		
		# Add the random noise TO the base offset
		offset = base_offset + Vector2(random_x, random_y)
		
		shake_strength = lerp(shake_strength, 0.0, decay * delta * 5) 
	else:
		shake_strength = 0.0
		offset = base_offset

func apply_shake(intensity):
	shake_strength = intensity
