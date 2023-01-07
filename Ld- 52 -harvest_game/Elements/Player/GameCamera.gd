extends Camera

export var player_path : NodePath

onready var player := get_node(player_path)

func _process(delta):
	translation.z = player.translation.z - 8
	translation.x = player.translation.x / 1.5
