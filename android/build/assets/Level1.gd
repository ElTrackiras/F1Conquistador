extends Node2D

@onready var background_image : Sprite2D = $CircuitNodes
@onready var player : CharacterBody2D = $F1Player
# Called when the node enters the scene tree for the first time.
func _ready():
	RenderingServer.set_default_clear_color(Color(0.584, 0.396, 0.82, 1))
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.position.y > 600:
		get_tree().reload_current_scene()
	
