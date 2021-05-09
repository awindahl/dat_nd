extends KinematicBody

const MAX_SPEED = 3
const JUMP_SPEED = 5
const ACCELERATION = 2
const DECELERATION = 4

onready var camera = $Target/Camera
onready var gravity = -ProjectSettings.get_setting("physics/3d/default_gravity")
onready var start_position = translation
var yaw = 0
var mouse_sensitivity = 1
var my_rotation
var target = null
var velocity = Vector3.ZERO
var speed = 2

func _ready():
	camera.get_parent().set_as_toplevel(true)

func _input(event):
	if event is InputEventMouseMotion:
		yaw = fmod(yaw - event.relative.x * mouse_sensitivity, 360)
		my_rotation = event.relative
		
#	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
#		var ray_length = 100000
#		var from = camera.project_ray_origin(get_viewport().get_mouse_position())
#		var to = from + camera.project_ray_normal(get_viewport().get_mouse_position()) * ray_length
#
#		var space_state = get_world().direct_space_state
#		target = space_state.intersect_ray(from, to).position
		
		
func _physics_process(delta):
	var lmb = Input.is_action_pressed("lmb")
	var rmb = Input.is_action_pressed("rmb")
	
	camera.get_parent().translation = translation 
	
	if lmb and not rmb:
		var ray_length = 100000
		var from = camera.project_ray_origin(get_viewport().get_mouse_position())
		var to = from + camera.project_ray_normal(get_viewport().get_mouse_position()) * ray_length
		
		var space_state = get_world().direct_space_state
		if space_state.intersect_ray(from, to).values() != []:
			target = space_state.intersect_ray(from, to).position
	
	if rmb and not lmb:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		camera.get_parent().rotate_y(deg2rad(my_rotation.x) * delta * mouse_sensitivity * 3)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	
	velocity.y += gravity * delta
	
	if target:
		look_at(target, Vector3.UP)
		rotation.x = 0
		velocity.x = -transform.basis.z.x * speed
		velocity.z = -transform.basis.z.z * speed
		if transform.origin.distance_to(target) < 1:
			target = null
			velocity = Vector3(0, velocity.y, 0)
	velocity = move_and_slide(velocity, Vector3.UP)
	print(velocity.y)
