extends MeshInstance

var area : Area
var broken = false
onready var test = self.mesh.get_surface_count()

var time_elapsed = 0
var duration = 1
var rng = RandomNumberGenerator.new()
var x_dir = 0

func _ready():
	rng.randomize()
	x_dir = rng.randf_range(-0.5, 0.5)
	area = get_child(0) as Area
	if area != null:
		area.connect("area_entered", self, "_on_area_entered")
	# envoyer valdinguer le prop et ptet le rendre transparent

func _process(delta):
	if broken:
		translation.z += 40 * delta
		translation.x += x_dir
		translation.y += 20 * delta
		rotation_degrees.x += 300 * delta
		time_elapsed += delta
		if time_elapsed >= duration:
			queue_free()

func _on_area_entered(collided_area: Area):
	if collided_area.is_in_group("player"):
		broken = true
		area.monitorable = false
		area.monitoring = false
