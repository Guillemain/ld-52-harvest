extends MarginContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Replay_pressed():
	get_tree().reload_current_scene()
	


func _on_Menu_pressed():
	get_tree().change_scene("res://EcranTitre.tscn")
