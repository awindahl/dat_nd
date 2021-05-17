extends KinematicBody

const MAX_SPEED = 3
const JUMP_SPEED = 5
const ACCELERATION = 2
const DECELERATION = 4
const TYPE = "PLAYER"

onready var camera = $Target/Camera
onready var gravity = -ProjectSettings.get_setting("physics/3d/default_gravity")
onready var start_position = translation
var yaw = 0
var mouse_sensitivity = 2
var my_rotation
var target = null
var velocity = Vector3.ZERO
var speed = 2
var busy = false

func _ready():
	camera.get_parent().set_as_toplevel(true)

func _input(event):
	if event is InputEventMouseMotion:
		yaw = fmod(yaw - event.relative.x * mouse_sensitivity, 360)
		my_rotation = event.relative
	
func _physics_process(delta):
	var lmb = Input.is_action_pressed("lmb")
	var rmb = Input.is_action_pressed("rmb")
	
	camera.get_parent().translation = translation 
	
	if lmb and not rmb and not busy:
		var ray_length = 100000
		var from = camera.project_ray_origin(get_viewport().get_mouse_position())
		var to = from + camera.project_ray_normal(get_viewport().get_mouse_position()) * ray_length
		
		var space_state = get_world().direct_space_state
		if space_state.intersect_ray(from, to).values() != []:
			target = space_state.intersect_ray(from, to).position
		
	if target:
		if transform.origin.distance_to(target) > 5 and not lmb:
			print(transform.origin.distance_to(target))
			target = null
			
		
	if rmb and not lmb:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		camera.get_parent().rotate_y(deg2rad(my_rotation.x) * delta * mouse_sensitivity * 3)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	
	velocity.y += gravity * delta
	
	if target and not busy:
		#look_at(target, Vector3.UP)
		rotation.x = 0
		rotation.z = 0
		
		var target_pos = target
		var new_trans = transform.looking_at(target_pos, Vector3.UP)
		transform = transform.interpolate_with(new_trans, delta*2)
		
		velocity.x = -transform.basis.z.x * speed
		velocity.z = -transform.basis.z.z * speed
		if transform.origin.distance_to(target) < 2 or busy:
			target = null
			velocity = Vector3(0, velocity.y, 0)
	
	if target == null:
		velocity = Vector3(0, velocity.y, 0)
		
	velocity = move_and_slide(velocity, Vector3.UP)
	#print(velocity.y)
