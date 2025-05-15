class_name PinballFlipper
extends Node2D

@export var clockwise: bool = true
@export var flip_angle: float = 75.0
@export var button: String = ""
@export var rotation_speed: int = 10
var base_angle
var active_angle

func _ready():
	base_angle = rotation_degrees
	if clockwise:
		active_angle = base_angle + flip_angle
	else:
		active_angle = base_angle - flip_angle

func flip(active: bool, delta) -> void:
	var direction = 1
	var new_angle = 0
	if not clockwise:
		direction = direction * -1
	if not active:
		direction = direction * -1
	new_angle = rotation_degrees + direction * rotation_speed * delta
	if clockwise:
		new_angle = clamp(new_angle, base_angle, active_angle)
	else:
		new_angle = clamp(new_angle, active_angle, base_angle)
	rotation_degrees = new_angle

func _physics_process(delta: float) -> void:
	if button != "":
		if (Input.is_action_pressed(button) and rotation_degrees != active_angle) or (not Input.is_action_pressed(button) and rotation_degrees != base_angle):
			flip(Input.is_action_pressed(button), delta)
