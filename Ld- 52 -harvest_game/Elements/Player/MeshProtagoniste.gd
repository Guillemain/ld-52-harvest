extends Spatial

# animation via code !

export var vitesse_roue = 1.0

var rouematerial : SpatialMaterial



# hot fix
var particuleA : Particles
var particuleB : Particles

func _ready():
	var animator := $AnimationPlayer as AnimationPlayer
	animator.play("idle_loop")
	rouematerial = ($RoueLow as MeshInstance).mesh.surface_get_material(0)
	#supersticiuous fix ?
	particuleA = get_node("../BetraveEffect/Particles") as Particles
	particuleB = get_node("../BetraveEffect/Boost") as Particles
#	particuleA.emitting = true
#	particuleB.emitting = true
#	#
#	particuleA.emitting = false
#	particuleB.emitting = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	rouematerial.uv1_offset += Vector3.RIGHT * delta * vitesse_roue

func _on_Player_turbo_start():
	particuleA.emitting = true
	particuleB.emitting = true

func _on_Player_turbo_end():
	particuleA.emitting = false
	particuleB.emitting = false
