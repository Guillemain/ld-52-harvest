extends KinematicBody

export var move_speed = 20
export var acceleration = 10
export var gravity = 0.98
export var max_fall_speed = 30

onready var cam = $CamBase
onready var mesh = $CSGBox

var acceleration_threshold = 0

var y_velo = 0

func _physics_process(delta):
	var move_vec := Vector3()
	
	# Auto move forward
	move_vec.z += 1
	
	# Direction calculation
	if Input.is_action_pressed("move_left"):
		move_vec.x += 1
	if Input.is_action_pressed("move_right"):
		move_vec.x -= 1
	
	move_vec = move_vec.normalized()
	
	#Apply rotation (maybe not necessary since we will probably only go straight)
	move_vec = move_vec.rotated(Vector3(0, 1, 0), rotation.y)
	
	# Calculate speed
	var current_speed = move_speed * clamp(acceleration_threshold / acceleration, 0, 1)
	move_vec *= current_speed
	
	# Apply gravity
	move_vec.y = y_velo
	
	move_and_slide(move_vec, Vector3(0, 1, 0))
	
	# Check if player is on floor to apply gravity or not
	var grounded = is_on_floor()
	y_velo -= gravity
	if grounded and y_velo <= 0:
		y_velo = -0.1
	if y_velo < -max_fall_speed:
		y_velo = -max_fall_speed
	
	# Increase acceleration threshold every frame but limit it to 1
	acceleration_threshold += delta
	acceleration_threshold = clamp(acceleration_threshold, 0, 1)
	
	print(current_speed)
