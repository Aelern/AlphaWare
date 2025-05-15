class_name PinballBumper
extends Node2D

@onready var extend_timer = $ExtendTimer
@onready var animated_sprite = $AnimatedSprite2D
@onready var hitbox_component = $HitboxComponent

func _ready():
	extend_timer.timeout.connect(retract)
	hitbox_component.hit_hurtbox.connect(extend)
	
func retract():
	animated_sprite.animation = "default"

func extend(_area):
	animated_sprite.animation = "extend"
	extend_timer.start()
