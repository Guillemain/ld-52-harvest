extends MeshInstance

var area : Area
var broken = false
onready var test = self.mesh.get_surface_count()

func _ready():
	area = get_child(0) as Area
	if area != null:
		area.connect("area_entered", self, "_on_area_entered")
	# envoyer valdinguer le prop et ptet le rendre transparent

func _on_area_entered(collided_area: Area):
	if collided_area.is_in_group("player"):
		broken = true
		area.monitorable = false
		area.monitoring = false
		queue_free()
