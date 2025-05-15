class_name BabyFrog
extends Node2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var collectbox = $CollectboxComponent

@export var id:int = 0

signal baby_rescued(baby)

func _ready() -> void:
	set_color()
	collectbox.collected.connect(collected)
	
func set_color():
	if id == 0:
		animated_sprite.play("green")
	elif id == 1:
		animated_sprite.play("pink")
	elif id == 2:
		animated_sprite.play("blue")
	else:
		animated_sprite.play("orange")
		
func collected(_hitbox):
	baby_rescued.emit(self)
