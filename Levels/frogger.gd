class_name Frogger
extends Microgame

@onready var life_label = $LivesLabel

@export var lives = 5
@export var map_manager:FroggerMapManager

func _ready() -> void:
	map_manager.game_won.connect(victory)
	map_manager.death.connect(life_lost)
	life_label.text = str(lives)

func victory():
	game_won.emit()

func life_lost():
	lives = lives - 1
	if lives < 0:
		game_lost.emit()
	else:
		life_label.text = str(lives)
