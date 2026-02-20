extends RigidBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_fuse_timer_timeout():
	var bodies = $Radius.get_overlapping_bodies()
	for obj in bodies:
		if obj.is_in_group("Box"):
			var source = self.global_transform.origin
			obj.Box_hit(source)
		
		if obj.is_in_group("HugeBall"):
			var source = self.global_transform.origin
			obj.HugeBall_hit(source)
	
	queue_free()
