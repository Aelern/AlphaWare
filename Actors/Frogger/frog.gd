class_name Frog
extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var hurtbox = $HurtboxComponent

@export var hop_speed = 200
@export var settle_speed = 300

var is_hopping = false
var prev_loc :Vector2
var target_loc :Vector2

signal ready_for_movement()
signal dying()

func _ready() -> void:
	ready_for_movement.emit()
	prev_loc = global_position
	target_loc = global_position
	hurtbox.take_damage.connect(take_damage)
	
func take_damage(_hitbox):
	dying.emit()

func set_animation(animation :String):
	if animated_sprite.sprite_frames.has_animation(animation):
		#animated_sprite.animation = animation
		animated_sprite.play(animation)

func start_hop(target :Vector2):
	set_animation("hop")
	is_hopping = true
	target_loc = target
	prev_loc = global_position

func stop_hop():
	set_animation("default")
	is_hopping = false
	ready_for_movement.emit()

func _physics_process(delta: float) -> void:
	if is_hopping:
		global_position = global_position.move_toward(target_loc, hop_speed * delta)
		if (target_loc - global_position).length() <= (target_loc - prev_loc).length() * 0.02:
			stop_hop()
	else:
		if global_position != target_loc:
			global_position = global_position.move_toward(target_loc, settle_speed * delta)

func kill():
	set_animation("dead")
