class_name Bowman
extends CharacterBody2D

@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var targetbox = $TargetboxComponent

@export var top_speed = 175
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
	var dir = 0
	if Input.is_action_pressed("left"):
		dir = dir - 1
	if Input.is_action_pressed("right"):
		dir = dir + 1
	if dir != 0:
		if animation_player.current_animation != "walk":
			animation_player.play("walk")
		own_speed.x = clamp(own_speed.x + acceleration * dir * delta, top_speed * -1, top_speed)
		if dir == 1 and not facing_right:
			facing_right = true
			sprite.flip_h = false
			targetbox.scale = Vector2(1, 1)
			own_speed.x = clamp(own_speed.x + deceleration * dir * delta, top_speed * -1, top_speed)
		elif dir == -1 and facing_right:
			facing_right = false
			sprite.flip_h = true
			targetbox.scale = Vector2(-1, 1)
			own_speed.x = clamp(own_speed.x + deceleration * dir * delta, top_speed * -1, top_speed)
	else:
		if animation_player.current_animation == "walk":
			animation_player.play("RESET")
		if own_speed.x > 0:
			own_speed.x = clamp(own_speed.x - deceleration * delta, 0, top_speed)
		elif own_speed.x < 0:
			own_speed.x = clamp(own_speed.x + deceleration * delta, top_speed * -1, 0)
	if not is_on_floor():
		player_state = States.AIR
		animation_player.play("jump")
	elif Input.is_action_just_pressed("action"):
		own_speed.y = jump_speed * -1
		player_state = States.AIR
		animation_player.play("jump")
	elif Input.is_action_just_pressed("action2"):
		player_state = States.ATTACK
		animation_player.play("attack")
		
	velocity = own_speed

func air_state(delta: float):
	own_speed.y = clamp(own_speed.y + (gravity * delta), jump_speed * -2, terminal_velocity)
	if is_on_floor():
		animation_player.play("RESET")
		player_state = States.GROUND
		own_speed.y = 0
	velocity = own_speed

func attack_state(delta: float):	
	#Eventually there might be stuff in here
	facing_right = facing_right

func hitstun_state(delta: float):
	print("Ouch")

func select_target():
	var targets = targetbox.get_targets()
	print(str(targets))
	
