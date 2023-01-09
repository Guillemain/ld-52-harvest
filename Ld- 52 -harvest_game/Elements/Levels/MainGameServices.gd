extends Spatial

const ui_end_game := preload("res://Elements/UI/UI_end_game.tscn")  

var radish : Spatial
var player : Spatial

var simple_counter = 0.0

func _ready():
	radish = $Radish
	player = $PlayerWithCamera/Player
func _physics_process(delta):
	var score = -(radish.global_translation.z - player.global_translation.z)
	simple_counter += delta
	print(simple_counter)
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
	var ui_instance := ui_end_game.instance() # creation du noeud
	add_child(ui_instance)
	var score = (radish.translation.z - player.translation.z) # à la zob
	#ui_instance.get_node("AnimationPlayer").play("Open")
	(ui_instance.get_node("VBoxContainer2/Score") as Label).text = "Score : " + str(floor(score)) + " meters "
	
