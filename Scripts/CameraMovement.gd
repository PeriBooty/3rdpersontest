extends Node3D

var mouse_cam_sensitivity = 0.005
var joystick_cam_sensitivity = 0.1
var twist_input = 0.0
var pitch_input = 0.0
var input_dir

@onready var twist_pivot = $h
@onready var pitch_pivot = $h/v

func _physics_process(_delta: float) -> void:
	input_dir = Input.get_vector("look_left", "look_right", "look_up", "look_down")
	twist_pivot.rotate_y(-input_dir.x * joystick_cam_sensitivity)
	pitch_pivot.rotate_x(-input_dir.y * joystick_cam_sensitivity)
	
	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	
	pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, deg_to_rad(-90), deg_to_rad(45))
	twist_input = 0.0
	pitch_input = 0.0

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = -event.relative.x * mouse_cam_sensitivity
			pitch_input = -event.relative.y * mouse_cam_sensitivity
