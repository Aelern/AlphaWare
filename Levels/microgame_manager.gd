class_name MicrogameManager
extends Node2D

@onready var game_spawner = $GameSpawner
@onready var intermission_timer = $IntermissionTimer

var win_count = 0
var lose_count = 0
var microgame_list = []
var active_microgame

func _ready():
	load_test_game_list()
	#load_game_list()
	intermission_timer.timeout.connect(start_a_game)
	start_a_game()

func start_a_game():
	var game_options = len(microgame_list)
	var game_choice = randi_range(0, game_options-1)
	var microgame = microgame_list.pop_at(game_choice)
	if game_options <= 1:
		load_game_list()
		#load_game_list()
	game_spawner.scene = load(microgame)
	active_microgame = game_spawner.spawn(Vector2(), game_spawner)
	active_microgame.game_won.connect(game_was_won)
	active_microgame.game_lost.connect(game_was_lost)

func load_game_list():
	microgame_list.append("res://Levels/pinball.tscn")
	microgame_list.append("res://Levels/rc_car_maze.tscn")
	microgame_list.append("res://Levels/frogger.tscn")
	microgame_list.append("res://Levels/maple.tscn")
	#microgame_list.append()

func load_test_game_list():
	microgame_list.append("res://Levels/maple.tscn")

func game_was_lost():
	print("FAILURE (awww)")
	lose_count = lose_count + 1
	postgame_cleanup()

func game_was_won():
	print("WINER")
	win_count = win_count + 1
	postgame_cleanup()

func postgame_cleanup():
	active_microgame.queue_free()
	intermission_timer.start()
