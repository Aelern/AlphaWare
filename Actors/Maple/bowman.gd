class_name Bowman
extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D

@export var top_speed = 200
@export var acceleration = 2000
@export var deceleration = 6000
@export var jump_speed = 420
@export var gravity = 1200
@export var terminal_velocity = 1200

var own_speed: Vector2
var facing_right = true

enum States {GROUND, AIR, ATTACK, HITSTUN}
var player_state = States.GROUND

func _physics_process(delta: float) -> void:
	match player_state:
		States.GROUND:
			grounded_state(delta)
		States.AIR:
			air_state(delta)
		States.ATTACK:
			attack_state(delta)
		States.HITSTUN:
			hitstun_state(delta)
	move_and_slide()

func grounded_state(delta: float):
	if not is_on_floor():
		player_state = States.AIR
	var dir = 0
	if Input.is_action_pressed("left"):
		dir = dir - 1
	if Input.is_action_pressed("right"):
		dir = dir + 1
	if dir != 0:
		own_speed.x = clamp(own_speed.x + acceleration * dir * delta, top_speed * -1, top_speed)
		if dir == 1 and not facing_right:
			facing_right = true
			animated_sprite.flip_h = false
			own_speed.x = clamp(own_speed.x + deceleration * dir * delta, top_speed * -1, top_speed)
		elif dir == -1 and facing_right:
			facing_right = false		
			animated_sprite.flip_h = true
			own_speed.x = clamp(own_speed.x + deceleration * dir * delta, top_speed * -1, top_speed)
	else:
		if own_speed.x > 0:
			own_speed.x = clamp(own_speed.x - deceleration * delta, 0, top_speed)
		elif own_speed.x < 0:
			own_speed.x = clamp(own_speed.x + deceleration * delta, top_speed * -1, 0)
	if Input.is_action_just_pressed("action"):
		own_speed.y = jump_speed * -1
		player_state = States.AIR
	velocity = own_speed

func air_state(delta: float):
	own_speed.y = clamp(own_speed.y + (gravity * delta), jump_speed * -2, terminal_velocity)
	if is_on_floor():
		player_state = States.GROUND
		own_speed.y = 0
	velocity = own_speed

func attack_state(delta: float):	
	print("Watch out, I'm shooting at you")

func hitstun_state(delta: float):
	print("Ouch")
