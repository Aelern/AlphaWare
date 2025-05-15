extends Microgame

@onready var car_spawner = $CarSpawner
@onready var rc_goal = $RCGoal
@onready var respawn_timer = $RespawnTimer
@onready var checkpoints = $Checkpoints
@onready var lives_label = $UI/Lives

@export var checkpoint_radius = 24
@export var lives = 3

var spawning_valid = true
var initial_life = true
var player_car: RCCar

func _ready():
	respawn_timer.timeout.connect(spawn_player)
	for checkpoint in checkpoints.get_children():
		if checkpoint is Checkpoint:
			checkpoint.checkpoint_reached.connect(update_spawn_point)
			checkpoint.adjust_collectbox_size(checkpoint_radius)
	rc_goal.goal_reached.connect(victory)

func spawn_player():
	if spawning_valid == false:
		return
	if initial_life == false:
		lives = lives - 1
	else:
		initial_life = false
	lives_label.text = "Lives: "  + str(lives)
	if lives >= 0:
		player_car = car_spawner.spawn(car_spawner.position, self)
		player_car.tree_exited.connect(respawn_timer.start)
	else:
		game_lost.emit()

func update_spawn_point(pos, rot):
	car_spawner.global_position = pos
	car_spawner.global_rotation = rot

func victory():
	game_won.emit()
	spawning_valid = false
