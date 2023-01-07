extends Spatial

export var spring_path : NodePath # Nodes where all its children representinf a spring
export var recall_force := 0.5 # The force for maitaining the object at the correct position 
export var drag_factor := 0.1 # the drag effect
export var current_speed := Vector3.ZERO # The current speed of the (do not modify)

var springs = []
func _ready():
	pass
	
func _physics_process(delta):
	var dxdt := Vector3.ZERO
	for node in get_node(spring_path).get_children():
		dxdt += (node.global_transform.origin - self.global_transform.origin)
	current_speed = (current_speed*drag_factor + dxdt * recall_force)
	self.global_transform.origin = self.global_transform.origin + current_speed * delta

