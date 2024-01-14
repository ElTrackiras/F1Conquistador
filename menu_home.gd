extends Node2D

func _on_touch_screen_button_released():
	print("Released")
	$PlayButton.scale.x = 5.156
	$PlayButton.scale.y = 1
	get_tree().change_scene_to_file("res://lets_go.tscn")


func _on_touch_screen_button_pressed():
	$PlayButton.scale.x = 5.5
	$PlayButton.scale.y = 1.15


func _on_quit_pressed():
	$Quit.scale.x = 5.5
	$Quit.scale.y = 1.15


func _on_quit_released():
	$Quit.scale.x = 5.156
	$Quit.scale.y = 1
	get_tree().quit()
