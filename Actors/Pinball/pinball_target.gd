class_name PinballTarget
extends StaticBody2D

@onready var health_component = $HealthComponent
@onready var hurtbox_component = $HurtboxComponent

func _ready() -> void:
	hurtbox_component.take_damage.connect(health_component.take_damage)
	health_component.health_below_zero.connect(die)

func die() -> void:
	queue_free()
