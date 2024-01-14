extends Node2D



func _on_restart_level_released():
	get_tree().change_scene_to_file("res://Level1.tscn")


func _on_menu_released():
	get_tree().change_scene_to_file("res://menu_home.tscn")
