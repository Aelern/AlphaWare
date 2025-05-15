class_name GravityComponent
extends Node

@export var gravity_direction = Vector2.DOWN
@export var gravity_strength = 1
@export var mass = 100

func forceOfGravity():
	return gravity_direction * gravity_strength * mass
