class_name Log
extends Node2D

const TILE_SIZE = 48

@onready var animated_sprite = $AnimatedSprite2D

var is_head = false
var is_tail = false
var speed = 80
var direction = Vector2.DOWN
var prev_tile: Vector2i

signal tile_updated(log, prev_tile, tile)

func _ready() -> void:
	set_sprite()
	direction = direction.normalized()
	prev_tile = real_coord_to_map_coord(global_position)
	global_rotation_degrees = 90

func set_sprite():
	if is_head:
		animated_sprite.animation = "head"
	elif is_tail:
		animated_sprite.animation = "tail"
	else:
		animated_sprite.animation = "body"

func _physics_process(delta: float) -> void:
	global_position = global_position + direction * speed * delta
	var tile = real_coord_to_map_coord(global_position)
	if tile != prev_tile:
		tile_updated.emit(self, prev_tile, tile)
		prev_tile = tile

func real_coord_to_map_coord(coord: Vector2):
	return Vector2i(round((coord.x - (TILE_SIZE / 2)) / TILE_SIZE), round((coord.y - (TILE_SIZE / 2)) / TILE_SIZE))
