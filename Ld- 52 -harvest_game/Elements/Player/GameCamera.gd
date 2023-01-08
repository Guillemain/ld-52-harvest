extends Camera

export var player_path : NodePath

onready var player := get_node(player_path)

var finished = false

func _process(delta):
	if finished:
		return
	translation.z = player.translation.z - 3
	translation.x = player.translation.x / 1.5
	translation.y = 2

func _on_Player_finished():
	finished = true
