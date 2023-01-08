extends Camera

export var player_path : NodePath

onready var player := get_node(player_path)

var finished = false
var original_fov = self.fov
var goal_fov = original_fov

func _process(delta):
	self.fov = lerp(self.fov, goal_fov, 0.05)
	if finished:
		return
	translation.z = player.translation.z - 3
	translation.x = player.translation.x / 1.5
	translation.y = 2
	

func _on_Player_finished():
	finished = true
	goal_fov = original_fov

func _on_Player_turbo_start():
	goal_fov = 90

func _on_Player_turbo_end():
	goal_fov = original_fov
