extends CharacterBody3D
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const PUSH_FORCE = 5.0
@export var player_health: int = 100
@export var look_sensitivity: float = 0.1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var Ball = preload("res://Object/ball.tscn")
var health: int
var can_throw = true
var mouse_sensitivity = 0.003

@onready var camera = $Neck/Camera3D
@onready var terrain_controller = get_parent().get_node("TerrainController")
@onready var health_bar = $UI/HealthBar/ProgressBar
@onready var movejoystick = get_node_or_null("UI/Move/MovementJoyStick")
@onready var lookjoystick = get_node_or_null("UI/Look/LookJoyStick")

func _ready():
	# Only capture mouse on desktop
	if not OS.has_feature("mobile"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	health = player_health
	health_bar.max_value = player_health
	health_bar.value = health
	
	# Make sure camera is active
	if camera:
		camera.make_current()
	
	# Debug
	print("Move joystick: ", movejoystick != null)
	print("Look joystick: ", lookjoystick != null)
	if lookjoystick:
		print("Look joystick active: ", lookjoystick.active)

func _unhandled_input(event):
	# Mouse look (desktop only)
	if event is InputEventMouseMotion and not OS.has_feature("mobile"):
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(70))
		
	if event.is_action_pressed("ui_escape") and not OS.has_feature("mobile"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta):
	if Input.is_action_just_pressed("escape"):
		get_tree().quit()
	
	# Handle look joystick (camera rotation)
	if lookjoystick and lookjoystick.active:
		var look_input = lookjoystick.get_value()
		var look_distance = lookjoystick.get_distance()
		
		# Only rotate if joystick is actually being used
		if look_distance > 0.1:  # Deadzone
			# Rotate player horizontally (Y axis)
			rotate_y(-look_input.x * look_sensitivity * delta * 60)
			
			# Rotate camera vertically (X axis)
			camera.rotate_x(-look_input.y * look_sensitivity * delta * 60)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(70))

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Handle jump - ONLY keyboard space, not touch
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction - support both joystick AND keyboard
	var input_dir: Vector2 = Vector2.ZERO
	
	# Check if movement joystick is active and being used
	if movejoystick and movejoystick.active:
		var move_input = movejoystick.get_value()
		var move_distance = movejoystick.get_distance()
		if move_distance > 0.1:  # Deadzone
			input_dir = move_input
	
	# Fall back to keyboard input if no joystick input
	if input_dir.length() == 0:
		input_dir = Input.get_vector("left", "right", "up", "down")
	
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
			get_tree().call_deferred("change_scene_to_file", "res://Scene/endless_world_lvl1.tscn")
			
		if collider.is_in_group("Portal2"):
			print("TELEPORT!")
			get_tree().call_deferred("change_scene_to_file", "res://Scene/combat_world.tscn")
		
		if collider is RigidBody3D:
			var push_direction = -collision.get_normal()
			var push_strength = PUSH_FORCE
			collider.apply_central_impulse(push_direction * push_strength * delta * 60)
			
	# Only allow ball throw on desktop with keyboard
	if not OS.has_feature("mobile"):
		ball_throw()

func ball_throw():
	# IMPORTANT: Make sure "throw_ball" is mapped to a KEYBOARD key, NOT mouse button
	if Input.is_action_just_pressed("throw_ball") and can_throw:
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
	rotation.y = 0
	camera.rotation.x = 0
	terrain_controller.reset_terrain()
