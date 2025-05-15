class_name HitboxComponent
extends Area2D

@export var damage: int = 0
@export var knockback: int = 0
	
signal hit_hurtbox(hurtbox)

func _ready() -> void:
	area_entered.connect(check_collision)
	
func check_collision(area: Area2D) -> void:
	if area is HurtboxComponent:
		if damage > 0:
			area.take_damage.emit(self)
		if knockback > 0:
			area.take_knockback.emit(self)
		hit_hurtbox.emit(area)
	elif area is CollectboxComponent:
		area.collected.emit(self)
	else:
		return
