extends Node2D




func _on_go_released():
	$Go.scale.x = 5.156
	$Go.scale.y = 1
	get_tree().change_scene_to_file("res://Level1.tscn")
