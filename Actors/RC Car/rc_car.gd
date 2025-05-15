class_name RCCar
extends CharacterBody2D

@export var acceleration: int = 1000
@export var decceleration: int = -1250
@export var top_speed: int = 500
@export var turn_rate: int = 400
var thrust: float = 0.0

@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	var input_direction = 0
	if Input.is_action_pressed("up"):
		input_direction = input_direction + 1
	if Input.is_action_pressed("down"):
		input_direction = input_direction - 1
	var turn_direction = 0
	if Input.is_action_pressed("right"):
		turn_direction = turn_direction + 1
	if Input.is_action_pressed("left"):
		turn_direction = turn_direction - 1

	if input_direction != 0:
		if thrust == 0:
			animated_sprite.animation = "driving"
			animated_sprite.play()
		thrust = clamp(thrust + acceleration * input_direction * delta, top_speed * -1, top_speed)
	elif abs(thrust) < top_speed * 0.05:
		if thrust != 0:
			animated_sprite.animation = "stationary"
		thrust = 0
	else:
		thrust = clamp(thrust + decceleration * sign(thrust) * delta, top_speed * -1, top_speed)
	
	if thrust != 0 and turn_direction != 0:
		if thrust < 0:
			turn_direction = turn_direction * -1
		var turn_amount = deg_to_rad(turn_rate) * delta * turn_direction * (abs(thrust) / top_speed)
		global_rotation = global_rotation + turn_amount
	var forward = Vector2.from_angle(global_rotation)

	velocity = forward * thrust
	
	var collisions = move_and_slide()
	if collisions:
		destroy_car()
		
func destroy_car():
	call_deferred("queue_free")
