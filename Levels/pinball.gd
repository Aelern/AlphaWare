class_name Pinball
extends Microgame

@onready var pinball_spawner = $PinballSpawner
@onready var respawn_timer = $RespawnTimer
@onready var life_indicator = $LifeIndicator
@onready var targets = $Targets
@onready var targets_remaining_count_label = $TargetCounter/CountLabel

var lives = 4
var target_count = 0
var pinball_ball: PinballBall

func _ready() -> void:
	respawn_timer.timeout.connect(spawn_pinball)
	respawn_timer.start()
	target_count = targets.get_child_count()
	targets.child_exiting_tree.connect(target_destroyed.unbind(1))
	targets_remaining_count_label.text = str(target_count)
	
func target_destroyed():
	target_count = target_count - 1
	targets_remaining_count_label.text = str(target_count)
	if target_count == 0 and lives > 0:
		pinball_ball.disconnect("tree_exited", respawn_timer.start)
		game_won.emit()

func spawn_pinball() -> void:
	lives = lives - 1
	life_indicator.get_child(-1).queue_free()
	if lives == 0:
		game_lost.emit()
		return
	pinball_ball = pinball_spawner.spawn(Vector2(), pinball_spawner)
	pinball_ball.tree_exited.connect(respawn_timer.start)
