class_name HealthComponent
extends Node

@export var max_health = 1
var health = max_health

signal health_changed() #Emit when health is adjusted
signal health_lost() #Emit when health goes down
signal health_gained() #Emit when health goes up
signal health_below_zero() #Emit when health changes from a value greater than zero to <= 0

func _ready():
	health = max_health

func take_damage(hitbox: HitboxComponent):
	var damage = hitbox.damage
	if damage == 0:
		return
	health_changed.emit()
	if damage < 0:
		health_gained.emit()
		if health - damage > max_health:
			damage = health - max_health
	elif damage > 0:
		health_lost.emit()
		if damage >= health and health > 0:
			health_below_zero.emit()
	health = health - damage
