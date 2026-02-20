extends RigidBody3D

var force = 350
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func HugeBall_hit(source):
	apply_central_force((global_transform.origin - source).normalized() * force)
