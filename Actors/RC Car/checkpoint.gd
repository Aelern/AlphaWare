class_name Checkpoint
extends Node2D

@onready var collectbox = $CollectboxComponent
@onready var collision_shape = $CollectboxComponent/CollisionShape2D

signal checkpoint_reached(pos, rot)

func _ready():
	collectbox.collected.connect(activate)

func activate(hitbox):
	checkpoint_reached.emit(global_position, global_rotation)
	call_deferred("queue_free")

func adjust_collectbox_size(rad):
	collision_shape.shape.radius = rad
