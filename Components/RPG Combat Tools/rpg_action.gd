class_name RPGAction
extends Resource

enum attackTypes {EFFECT, PHYSICAL, MAGIC}
@export var attackClass:attackTypes = attackTypes.EFFECT

func trigger():
	#Deal damage to targets 
	#Play animation
	print("bang")
