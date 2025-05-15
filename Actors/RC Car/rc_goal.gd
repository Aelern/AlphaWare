extends StaticBody2D

@onready var collectbox = $CollectboxComponent

signal goal_reached()

func _ready():
	collectbox.collected.connect(goal)

func goal(hitbox):
	goal_reached.emit()
