extends CharacterBody3D

var speed = 10.0
var follow_speed = 10.0
var turn_speed = 30

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var parent

@onready var cam_h = $"../CamOrigin/h"
@onready var cam_v = $"../CamOrigin/h/v"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	capture_mouse()
	
	parent = get_parent()

func _unhandled_input(_event: InputEvent) -> void:
	# if "exit" (esc) is pressed, close game
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	parent.position = lerp(parent.position, position, delta * follow_speed)
	#parent.position = position

func _physics_process(delta):
	# turn player inputs into a vector
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backwards")
	
	var direction = (cam_h.transform.basis * Vector3(input_dir.x, 0, input_dir.y))
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		
		rotation.y = lerp_angle(rotation.y, atan2(-direction.x, -direction.z), turn_speed * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	move_and_slide()


func capture_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func release_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
