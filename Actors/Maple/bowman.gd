class_name Bowman
extends CharacterBody2D

@export var top_speed = 200
@export var acceleration = 25
@export var jump_speed = 400
@export var gravity = 50
@export var terminal_velocity = 300

var own_speed: Vector2
var facing_right = false

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

func grounded_state(delta: float):
	print("Ayy I'm walkin' here")
	if not is_on_floor():
		player_state = States.AIR
	if Input.is_action_pressed("left"):
		own_speed.x = clamp(own_speed.x - acceleration, top_speed * -1, top_speed)
	if Input.is_action_pressed("right"):
		own_speed.x = clamp(own_speed.x + acceleration, top_speed * -1, top_speed)
	if Input.is_action_just_pressed("action"):
		own_speed.y = jump_speed * -1
		player_state = States.AIR
	velocity = own_speed

func air_state(delta: float):
	print("Yoooooooooooooop")
	own_speed.y = clamp(own_speed.y + gravity, jump_speed * -2, terminal_velocity)
	if is_on_floor():
		player_state = States.GROUND
		own_speed.y = 0

func attack_state(delta: float):	
	print("Watch out, I'm shooting at you")

func hitstun_state(delta: float):
	print("Ouch")
