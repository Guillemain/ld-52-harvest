extends KinematicBody

export var move_forward_speed = 20
export var move_side_speed = 20
export var acceleration_forward = 10
export var acceleration_side = 10.0
export var gravity = 0.98
export var max_fall_speed = 30

onready var cam = $CamBase

var total_time = 0
var total_time_turn = 0

var y_velo = 0

func _physics_process(delta):
	var movement_vector := calculate_forward_vector() + calculate_side_vector(delta)
	total_time += delta
	
	#Apply rotation (maybe not necessary since we will probably only go straight)
	movement_vector = movement_vector.rotated(Vector3(0, 1, 0), rotation.y)
	
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
	var move_forward_vec := Vector3()
	
	# Auto move forward
	move_forward_vec.z += 1
	
	move_forward_vec = move_forward_vec.normalized()
	
	# Increase acceleration_forward threshold every frame but limit it to 1
	var acceleration_threshold = clamp(total_time / acceleration_forward, 0, 1)
	# Calculate speed
	move_forward_vec *= move_forward_speed * acceleration_threshold
	
	return move_forward_vec

func calculate_side_vector(delta) -> Vector3:
	var move_side_vec := Vector3()
	
	# Direction calculation
	if Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right"):
		total_time_turn = 0
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		total_time_turn += delta
		if Input.is_action_pressed("move_left"):
			move_side_vec.x += 1
		if Input.is_action_pressed("move_right"):
			move_side_vec.x -= 1
	
	move_side_vec = move_side_vec.normalized()
	var acceleration_threshold = clamp(total_time_turn / acceleration_side, 0, 1)
	var current_speed = move_side_speed * acceleration_threshold
	move_side_vec *= move_side_speed * acceleration_threshold
	
	print(current_speed)
	
	return move_side_vec
