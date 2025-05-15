class_name PinballBall
extends RigidBody2D

@onready var hurtbox_component = $HurtboxComponent
@onready var on_screen_notifier = $VisibleOnScreenNotifier2D

func _ready() -> void:
	hurtbox_component.take_knockback.connect(bounce)
	on_screen_notifier.screen_exited.connect(queue_free)

func bounce(_area: HitboxComponent):
	var knockback_vector = _area.global_position.direction_to(global_position) * _area.knockback
	apply_impulse(knockback_vector)
