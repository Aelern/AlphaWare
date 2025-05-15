class_name LogSpawner
extends Node2D

const TILE_SIZE = 48

@onready var spawner_component = $SpawnerComponent
@onready var spawn_timer = $SpawnTimer

@export var log_length = 4
@export var speed:int = 50
@export var direction:Vector2 = Vector2.DOWN
@export var spawn_time:float = 6.0

signal log_created(log)

func _ready():
	direction = direction.normalized()
	spawn_timer.wait_time = spawn_time
	spawn_timer.timeout.connect(spawn_log)

func spawn_log():
	for i in range(log_length):
		var wood_log = spawner_component.spawn(Vector2(), self)
		wood_log.speed = speed
		wood_log.direction = direction
		if i == 0:
			if direction == Vector2.UP:
				wood_log.is_tail = true
			else:
				wood_log.is_head = true
		elif i == log_length - 1:
			if direction == Vector2.UP:
				wood_log.is_head = true
			else:
				wood_log.is_tail = true
		wood_log.position = position + i * (direction * -1 * TILE_SIZE)
		log_created.emit(wood_log)
