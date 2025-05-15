class_name CarSpawner
extends Node2D

@onready var spawner_component = $SpawnerComponent
@onready var spawn_timer = $SpawnTimer

@export var speed:int = 85
@export var direction:Vector2 = Vector2.DOWN
@export var spawn_time:float = 3.0

func _ready():
	direction = direction.normalized()
	spawn_timer.wait_time = spawn_time
	spawn_timer.timeout.connect(spawn_car)	

func spawn_car():
	var car = spawner_component.spawn(Vector2(), self)
	car.speed = speed
	car.direction = direction
