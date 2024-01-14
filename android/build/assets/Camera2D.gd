extends Camera2D

var shake_amount = 0
var default_offset = offset
@onready var tween : Tween = create_tween()
@onready var timer = $Timer
var shake_time = 30
var shake_type : String = "PLAYER_DAMAGED"

func _ready():
	set_process(false)
	randomize()

func _process(delta):
	if shake_type == "PLAYER_DAMAGED":
		offset = Vector2(randf_range(-1, 1) * shake_amount, randf_range(-1, 1) * shake_amount)
		shake_time -= 1
		if shake_time <= 0:
			set_process(false)
			shake_time = 30
	
	elif shake_type == "PLAYER_ATTACKING":
		offset = Vector2(randf_range(-1, 1) * 10, randf_range(-1, 1) * shake_amount)
		shake_time -= 7
		if shake_time <= 0:
			set_process(false)
			shake_time = 30
		

func shake(amount, type):
	shake_type = type
	shake_amount = amount
	set_process(true)




