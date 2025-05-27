class_name Arrow
extends Node2D

@onready var animated_sprite = $AnimatedSprite2D

var target: Node2D
var range:float = 600.0
var speed = 400
var moving = false

func _ready() -> void:
	animated_sprite.animation_finished.connect(animation_manager)

func _physics_process(delta: float) -> void:
	var new_position = Vector2()
	if moving:
		new_position = global_position.move_toward(target.global_position, speed * delta)
	range = range - new_position.length()
	if range < 0:
		queue_free()
	if new_position == target.global_position:
		animation_manager()
	global_position = new_position

func animation_manager() -> void:
	if animated_sprite.animation == "appear":
		animated_sprite.play("default")
		animated_sprite.disconnect("animation_finished", animation_manager)
		moving = true
	elif animated_sprite.animation == "default":
		animated_sprite.play("impact")
		animated_sprite.animation_finished.connect(queue_free)
