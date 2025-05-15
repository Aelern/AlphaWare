extends StaticBody2D

@onready var visible_on_screen_notifier = $VisibleOnScreenNotifier2D

@export var speed = 85
@export var direction:Vector2 = Vector2.RIGHT

func _ready() -> void:
	visible_on_screen_notifier.screen_exited.connect(queue_free)
	direction = direction.normalized()
	global_rotation = direction.angle()

func _physics_process(delta: float) -> void:
	global_position = global_position + direction * speed * delta
