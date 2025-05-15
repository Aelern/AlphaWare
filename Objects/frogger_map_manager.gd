class_name FroggerMapManager
extends Node

const TILE_SIZE = 48
const MAP_WIDTH = 18
const MAP_HEIGHT = 9

@export var lives:int = 5
@export var terrain_tile_map: TileMapLayer
@export var frog_spawner: SpawnerComponent
@export var lily_pad_folder: Node
@export var log_spawner_folder: Node
@export var baby_folder: Node

@onready var respawn_timer = $RespawnTimer

enum TerrainTypes {GRASS, WATER, ROAD, BUSH}

var map_dimensions = Vector2()
var map_terrain = []
var map_objects = []
var frog_move_ready = false
var freeze_frog = false
var spawn_point = Vector2i()
var frog_location = Vector2i()
var player_frog :Frog
var baby_count = 0

signal game_won
signal death

func _ready() -> void:
	load_map_terrain()
	spawn_point = real_coord_to_map_coord(frog_spawner.global_position)
	spawn_frog()

func spawn_frog():
	player_frog = frog_spawner.spawn(frog_spawner.global_position, frog_spawner, frog_spawner.global_rotation)
	player_frog.position = Vector2()
	player_frog.target_loc = frog_spawner.global_position
	frog_location = spawn_point
	player_frog.ready_for_movement.connect(hop_complete)
	player_frog.tree_exited.connect(spawn_frog)
	player_frog.dying.connect(destroy_frog)
	freeze_frog = false

func destroy_frog():
	if not freeze_frog:
		player_frog.is_hopping = false
		player_frog.target_loc = player_frog.global_position
		respawn_frog()
		player_frog.kill()
		death.emit()

func respawn_frog():
	frog_move_ready = false
	freeze_frog = true
	respawn_timer.start()
	respawn_timer.timeout.connect(player_frog.queue_free)

func hop_complete():
	if map_objects[frog_location.x][frog_location.y] != null:
		frog_move_ready = true
		return
	if tile_lethal(cell_to_terrain(frog_location)):
		destroy_frog()
	else:
		frog_move_ready = true

func cell_to_terrain(cell: Vector2) -> TerrainTypes:
	var type :TerrainTypes
	var atlas_coord = terrain_tile_map.get_cell_atlas_coords(cell)
	if atlas_coord.x == 0:
		if atlas_coord.y == 0:
			type = TerrainTypes.GRASS
		else:
			type = TerrainTypes.ROAD
	else:
		if atlas_coord.y == 0:
			type = TerrainTypes.WATER
		else:
			type = TerrainTypes.BUSH
	return type

func map_coord_to_real_coord(coord: Vector2i):
	return Vector2(coord.x * TILE_SIZE + (TILE_SIZE / 2), coord.y * TILE_SIZE + (TILE_SIZE / 2))

func real_coord_to_map_coord(coord: Vector2):
	return Vector2i(round((coord.x - (TILE_SIZE / 2)) / TILE_SIZE), round((coord.y - (TILE_SIZE / 2)) / TILE_SIZE))

func tile_lethal(tile_type: TerrainTypes) -> bool:
	if tile_type == TerrainTypes.WATER:
		return true
	else:
		return false

func update_lily_pad(lily_pad :LilyPad):
	var pad_position = real_coord_to_map_coord(lily_pad.global_position)
	if lily_pad.is_floating:
		map_objects[pad_position.x][pad_position.y] = lily_pad
	else:	
		map_objects[pad_position.x][pad_position.y] = null
		if pad_position == frog_location:
			if player_frog.is_hopping == false:
				destroy_frog()

func load_map_terrain():
	map_dimensions = terrain_tile_map.get_used_rect().size
	for x in range(map_dimensions.x):
		map_terrain.append([])
		map_objects.append([])
		for y in range(map_dimensions.y):
			map_terrain[x].append(cell_to_terrain(Vector2(x, y)))
			map_objects[x].append(null)
	for lily_pad in lily_pad_folder.get_children():
		if lily_pad is LilyPad:
			if lily_pad.start_floating:
				var pad_position = real_coord_to_map_coord(lily_pad.global_position)
				map_objects[pad_position.x][pad_position.y] = lily_pad
			lily_pad.changing_state.connect(update_lily_pad)
	for log_spawner in log_spawner_folder.get_children():
		if log_spawner is LogSpawner:
			log_spawner.log_created.connect(setup_new_log)
	for baby_frog in baby_folder.get_children():
		if baby_frog is BabyFrog:
			baby_count = baby_count + 1
			baby_frog.baby_rescued.connect(baby_rescued)

func baby_rescued(baby_frog:BabyFrog):
	baby_count = baby_count - 1
	baby_frog.call_deferred("queue_free")
	if baby_count <= 0:
		game_won.emit()
	else:
		respawn_frog()

func setup_new_log(wood_log:Log):
	wood_log.tile_updated.connect(log_update)

func log_update(wood_log, prev_tile, tile):
	var exists = false
	var existed = false
	if tile.x >= 0 and tile.x < MAP_WIDTH and tile.y >= 0 and tile.y < MAP_HEIGHT:
		map_objects[tile.x][tile.y] = wood_log
		exists = true
	if prev_tile.x >= 0 and prev_tile.x < MAP_WIDTH and prev_tile.y >= 0 and prev_tile.y < MAP_HEIGHT:
		if map_objects[prev_tile.x][prev_tile.y] == wood_log:
			map_objects[prev_tile.x][prev_tile.y] = null
		existed = true
	if prev_tile == frog_location:
		if exists:
			frog_location = tile
		else:
			destroy_frog()
			wood_log.call_deferred("queue_free")

func _physics_process(delta: float) -> void:
	if frog_move_ready and not freeze_frog:
		var target_map_tile = frog_location
		if Input.is_action_just_pressed("up"):
			target_map_tile = frog_location + Vector2i.UP
			player_frog.global_rotation = 0
		elif Input.is_action_just_pressed("right"):
			target_map_tile = frog_location + Vector2i.RIGHT
			player_frog.global_rotation = PI/2
		elif Input.is_action_just_pressed("down"):
			target_map_tile = frog_location + Vector2i.DOWN
			player_frog.global_rotation = PI
		elif Input.is_action_just_pressed("left"):
			target_map_tile = frog_location + Vector2i.LEFT
			player_frog.global_rotation = 3*PI/2
		else:
			if map_objects[frog_location.x][frog_location.y] != null:
				player_frog.target_loc = map_objects[frog_location.x][frog_location.y].global_position
		if target_map_tile != frog_location and approve_frog_move(target_map_tile):
			frog_move_ready = false
			var target_hop_coord = map_coord_to_real_coord(target_map_tile)
			if map_objects[target_map_tile.x][target_map_tile.y] != null:
				target_hop_coord = map_objects[target_map_tile.x][target_map_tile.y].global_position
			player_frog.start_hop(target_hop_coord)
			frog_location = target_map_tile #delay this to when frog gets halfway there

func approve_frog_move(target: Vector2) -> bool:
	if target.x < 0 or target.x >= map_dimensions.x:
		return false
	elif target.x < 0 or target.x >= map_dimensions.x:
		return false
	if cell_to_terrain(target) == TerrainTypes.BUSH:
		return false
	return true
