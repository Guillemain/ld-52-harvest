extends Control

signal StartDone

export var two : Texture
export var one : Texture

onready var goText = $GoText
onready var numberText = $NumberText
onready var timer = $Timer
onready var currentText : TextureRect

var total_time = 0.0
var state = 3
var appearing = true
var scale = Vector2.ZERO

func _ready():
	currentText = numberText

func _process(delta):
	if total_time < 0.35 and appearing:
		scale.x = total_time / 0.35
		scale.y = total_time / 0.35
		currentText.rect_scale = scale
	elif total_time < 0.35 and !appearing:
		scale.x = 1 - (total_time / 0.35)
		scale.y = 1 - (total_time / 0.35)
		currentText.rect_scale = scale
	else:
		if !appearing:
			scale.x = 0
			scale.y = 0
		else:
			scale.x = 1
			scale.y = 1
		currentText.rect_scale = scale
		if timer.is_stopped():
			if state == 0:
				timer.wait_time = 0.5
			timer.start()
	total_time += delta

func _on_Timer_timeout():
	if appearing:
		appearing = false
	else:
		state -= 1
		appearing = true
	if state < 0:
		queue_free()
	total_time = 0
	timer.stop()
	change_texture()

func change_texture():
	if state == 2:
		currentText.texture = two
	if state == 1:
		currentText.texture = one
	if state == 0:
		emit_signal("StartDone")
		currentText.visible = false
		currentText = goText
		currentText.visible = true
