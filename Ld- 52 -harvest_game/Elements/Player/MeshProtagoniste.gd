extends Spatial

# animation via code !

export var vitesse_roue = 1.0

var rouematerial : SpatialMaterial

func _ready():
	var animator := $AnimationPlayer as AnimationPlayer
	animator.play("idle_loop")
	rouematerial = ($RoueLow as MeshInstance).mesh.surface_get_material(0)
	
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	rouematerial.uv1_offset += Vector3.RIGHT * delta * vitesse_roue


