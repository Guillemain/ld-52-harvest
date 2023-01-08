extends KinematicBody

signal finished
signal turbo_start
signal turbo_end

export var move_forward_speed = 20.0
export var move_side_speed = 20
export var acceleration_forward = 10
export var acceleration_side = 10.0
export var max_turn_angle = 45
export var gravity = 0.98
export var max_fall_speed = 30

onready var mesh = $Mesh
onready var turboTimer = $TurboTimer
onready var mesh_base_angle = mesh.rotation_degrees.y

var total_time = 0
var total_time_turn = 0
var goal_angle = 0
var goal_x = 0
var current_speed = 0
var original_forward_speed = move_forward_speed

var y_velo = 0

var started = false

func _physics_process(delta):
	if !started:
		return
	
	var movement_vector := calculate_forward_vector() + calculate_side_vector(delta)
	total_time += delta
	
	#Apply rotation (maybe not necessary since we will probably only go straight)
	movement_vector = movement_vector.rotated(Vector3(0, 1, 0), rotation.y)
	
	current_speed = movement_vector.length()
	
	# Apply gravity
	movement_vector.y = y_velo
	
	move_and_slide(movement_vector, Vector3(0, 1, 0))
	
	# Check if player is on floor to apply gravity or not
	var grounded = is_on_floor()
	y_velo -= gravity
	if grounded and y_velo <= 0:
		y_velo = -0.1
	if y_velo < -max_fall_speed:
		y_velo = -max_fall_speed

func calculate_forward_vector() -> Vector3:
	var move_forward_vec := Vector3.ZERO
	
	# Auto move forward
	move_forward_vec.z += 1
	
	move_forward_vec = move_forward_vec.normalized()
	
	# Increase acceleration_forward threshold every frame but limit it to 1
	var acceleration_threshold = clamp(total_time / acceleration_forward, 0, 1)

	# Calculate speed
	move_forward_vec *= move_forward_speed * acceleration_threshold
	
	return move_forward_vec

func calculate_side_vector(delta) -> Vector3:
	var move_side_vec := Vector3.ZERO
	
	if Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right"):
		total_time_turn = 0
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		total_time_turn += delta
		if Input.is_action_pressed("move_left"):
			goal_x = 1
		if Input.is_action_pressed("move_right"):
			goal_x = -1
	else:
		goal_x = lerp(goal_x, 0, 0.1)
	
	var acceleration_threshold = clamp(total_time_turn / acceleration_side, 0, 1)
	move_side_vec.x = goal_x
	rotate_mesh(move_side_vec.x, acceleration_threshold)
	move_side_vec *= move_side_speed * acceleration_threshold
	return move_side_vec

# Slowly rotate mesh to follow the turn, with interpolation to smoothly get back to original rotation
func rotate_mesh(side, acceleration_threshold):
	goal_angle = max_turn_angle * acceleration_threshold * side
	mesh.rotation_degrees.y = mesh_base_angle + goal_angle
	#mesh.rotation_degrees.y = lerp(mesh.rotation_degrees.y, mesh_base_angle + goal_angle, 0.1)

func _on_TriggerShape_area_entered(area: Area):
	if area.is_in_group("jump20"):
		y_velo = 10
	if area.is_in_group("obstacle50"):
		total_time -= acceleration_forward * 0.5
		_fx_obstacle()
	if area.is_in_group("obstacle35"):
		total_time -= acceleration_forward * 0.35
		_fx_obstacle()
	if area.is_in_group("obstacle20"):
		total_time -= acceleration_forward * 0.2
		_fx_obstacle()
	if area.is_in_group("turbeets"):
		turboTimer.start()
		emit_signal("turbo_start")
		move_forward_speed = original_forward_speed * 2
	if area.is_in_group("finish"):
		emit_signal("finished")
	if total_time < 0:
		total_time = 0

func _on_Control_StartDone():
	started = true

func _fx_obstacle():
	Engine.time_scale = 0.01
	yield(get_tree().create_timer(0.01*1),"timeout")
	Engine.time_scale = 1

func _on_TurboTimer_timeout():
	print("oui")
	move_forward_speed = original_forward_speed
	emit_signal("turbo_end")
	turboTimer.stop()
