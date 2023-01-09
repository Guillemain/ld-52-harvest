extends KinematicBody

export var move_forward_speed = 20
export var move_side_speed = 20
export var acceleration_forward = 10
export var acceleration_side = 10.0
export var max_turn_angle = 45
export var gravity = 0.98
export var max_fall_speed = 30

onready var anim = $radis/AnimationPlayer

var total_time = 0
var total_time_turn = 0
var goal_angle = 0
var goal_x = 0
var current_speed = 0

var y_velo = 0

var started = false

func _ready():
	anim.play("Idle_loop")
	rotation_degrees.y = 180

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
	
	if translation.x < goal_x - 0.2:
		move_side_vec.x = 0.5
	if translation.x > goal_x + 0.2:
		move_side_vec.x = -0.5
	
	move_side_vec *= move_side_speed
	return move_side_vec

func _on_TriggerShape_area_entered(area: Area):
	if area.is_in_group("jump20"):
		y_velo = 10
	if area.is_in_group("jumper_radis"):
		y_velo = 15
	if area.is_in_group("obstacle50"):
		total_time -= acceleration_forward * 0.4
	if area.is_in_group("obstacle35"):
		total_time -= acceleration_forward * 0.25
	if area.is_in_group("obstacle20"):
		total_time -= acceleration_forward * 0.1
	if total_time < 0:
		total_time = 0

func _on_Control_OneDone():
	rotation_degrees.y = 0
	anim.play("Run_loop")
	started = true
