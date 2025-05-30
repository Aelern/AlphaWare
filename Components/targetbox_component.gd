class_name TargetboxComponent
extends Area2D

signal target_acquired(hurtbox)

func get_targets():
	monitoring = true
	var targets = get_overlapping_areas()
	monitoring = false
	return targets
