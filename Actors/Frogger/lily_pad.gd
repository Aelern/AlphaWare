class_name LilyPad
extends Node2D

@onready var state_timer = $StateTimer
@onready var animated_sprite = $AnimatedSprite2D

@export var surface_time = 3.5
@export var sink_time = 1.0
@export var rotation_speed = 8
@export var start_floating = true

var is_floating = true

signal changing_state(lily_pad)

func _ready() -> void:
	if start_floating:
		surface()
	else:
		sink()

func _physics_process(delta: float) -> void:
	global_rotation_degrees = global_rotation_degrees - rotation_speed * delta
	if global_rotation_degrees < 0:
		global_rotation_degrees = global_rotation_degrees + 360
		
func surface():
	is_floating = true
	animated_sprite.animation = "surface"
	state_timer.wait_time = surface_time
	if state_timer.is_connected("timeout", surface):
		state_timer.disconnect("timeout", surface)
	state_timer.timeout.connect(sink)
	state_timer.start()
	changing_state.emit(self)
	
func sink():
	is_floating = false
	animated_sprite.animation = "sunk"
	state_timer.wait_time = surface_time
	if state_timer.is_connected("timeout", sink):
		state_timer.disconnect("timeout", sink)
	state_timer.timeout.connect(surface)
	state_timer.start()
	changing_state.emit(self)
