extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_LvlTuto_pressed():
	get_tree().change_scene("res://Elements/Levels/Level_Tuto.tscn")


func _on_Lvl2_pressed():
	get_tree().change_scene("res://Elements/Levels/Level_Aune.tscn")


func _on_LevelButton3_pressed():
	get_tree().change_scene("res://Elements/Levels/lvl_adab.tscn")


func _on_TextureButton_pressed():
	$MainMenu.visible = true
	$Credit.visible = false
	


func _on_Credit_pressed():
	$MainMenu.visible = false
	$Credit.visible = true
