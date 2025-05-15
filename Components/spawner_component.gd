class_name SpawnerComponent
extends Node2D

@export var scene: PackedScene

func spawn(spawn_position: Vector2 = global_position, parent: Node = get_tree().current_scene, spawn_rotation: float = global_rotation) -> Node:
	var spawned_object = scene.instantiate()
	spawned_object.global_position = spawn_position
	if "global_rotation" in spawned_object:
		spawned_object.rotation = spawn_rotation
	parent.call_deferred("add_child", spawned_object)
	return spawned_object
