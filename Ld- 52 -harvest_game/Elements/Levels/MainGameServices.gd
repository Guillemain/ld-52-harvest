extends Spatial

const ui_end_game_win := preload("res://Elements/UI/UI_end_game.tscn")  
const ui_end_game_failed := preload("res://Elements/UI/UI_end_game_failed.tscn")  
var radish : Spatial
var player : Spatial

var simple_counter = 0.0

func _ready():
	radish = $Radish
	player = $PlayerWithCamera/Player

func _process(delta):
	if(Input.is_action_just_pressed("replay")):
		get_tree().reload_current_scene()
		

func _physics_process(delta):
	var score = -(radish.global_translation.z - player.global_translation.z)
	simple_counter += delta
	if(score < 0):
		if(simple_counter > 0.5 ):
			if(simple_counter>1.0) : 
				simple_counter = 0.0 
			$HUD/VBoxContainer/Meters.add_color_override("font_color",Color.lightcoral)
		else :
			$HUD/VBoxContainer/Meters.add_color_override("font_color",Color8(209, 69, 59,255))
		
		$HUD/VBoxContainer/Meters.text = str(floor(score)) + " meters "
	else:
		$HUD/VBoxContainer/Meters.add_color_override("font_color",Color.lightgoldenrod)
		$HUD/VBoxContainer/Meters.text = " " + str(floor(score)) + " meters "
	
func _on_Player_finished():
	var score = -(radish.global_translation.z - player.global_translation.z) # à la zob
	if(score > 0):
		var ui_instance := ui_end_game_win.instance() # creation du noeud
		add_child(ui_instance)
		#ui_instance.get_node("AnimationPlayer").play("Open")
		(ui_instance.get_node("VBoxContainer2/Score") as Label).text = "Score : " + str(floor(score)) + " meters "
	else : 
		var ui_instance := ui_end_game_failed.instance() # creation du noeud
		add_child(ui_instance)
		#ui_instance.get_node("AnimationPlayer").play("Open")
		(ui_instance.get_node("VBoxContainer2/Score") as Label).text = "Your were at " + str(floor(score)) + " meters from it! "

		
