extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const PUSH_FORCE = 5.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var Ball = preload("res://Object/ball.tscn")

var can_throw = true
var sensitivity = 0.003
@onready var camera = $Neck/Camera3D
@onready var terrain_controller = get_parent().get_node("TerrainController")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * sensitivity)
		camera.rotate_x(-event.relative.y * sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(70))

func _process(delta):
	if Input.is_action_just_pressed("escape"):
		get_tree().quit()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
	# Push RigidBody3D objects
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		


		if collider.is_in_group("Obstacle"):
			print("HIT")
			_restart_game()
			
		if collider.is_in_group("Portal"):
			print("TELEPORT!")
			get_tree().change_scene_to_file("res://Scene/endless_world_lvl1.tscn")

		
		if collider is RigidBody3D:
			var push_direction = -collision.get_normal()
			var push_strength = PUSH_FORCE
			
			# Apply impulse to push the object
			collider.apply_central_impulse(push_direction * push_strength * delta * 60)
			
	ball_throw()
	
func ball_throw():
	if Input.is_action_pressed("throw_ball") && can_throw:
		var ball_instantiate = Ball.instantiate()
		ball_instantiate.position = $Neck/Camera3D/Ballpos.global_position
		get_tree().current_scene.add_child(ball_instantiate)
		
		can_throw = false
		$ThrowTimer.start()
		
		var force = -10
		var up_direction = 3.5
		
		var playerRotation = $Neck.global_transform.basis.z.normalized()
		
		ball_instantiate.apply_central_impulse(playerRotation * force + Vector3(0, up_direction, 0))


func _on_throw_timer_timeout():
	can_throw = true
	
func _restart_game():
	global_position = Vector3(0, 2, 0)
	velocity = Vector3.ZERO
	terrain_controller.reset_terrain()
