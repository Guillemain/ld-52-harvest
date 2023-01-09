extends Camera

export var player_path : NodePath

onready var player := get_node(player_path)

var finished = false
var original_fov = self.fov
var goal_fov = original_fov

var shake_amout := 0.1
var shake_duration := 0.1
var is_shaking := false
onready var rand = RandomNumberGenerator.new()

func _ready():
	rand.randomize()

func _process(delta):
	self.fov = lerp(self.fov, goal_fov, 0.05)
	if finished:
		return
	if not(is_shaking):
		translation.z = player.translation.z - 3
		translation.x = player.translation.x / 1.5
		translation.y = 2
	else:
		translation.z = player.translation.z - 3 
		translation.x = player.translation.x / 1.5 + rand.randf_range(-shake_amout, shake_amout)
		translation.y = 2 + rand.randf_range(-shake_amout, shake_amout)

func _do_shake():
	if(not is_shaking):
		is_shaking = true
		(yield(get_tree().create_timer(shake_duration),"timeout"))
		is_shaking = false

func _on_Player_finished():
	finished = true
	goal_fov = original_fov

func _on_Player_turbo_start():
	goal_fov = 90

func _on_Player_turbo_end():
	goal_fov = original_fov


func _on_Player_hit_something():
	_do_shake()
