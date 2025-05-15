class_name RPGCombatant
extends Resource

var maxHP = 0
var HP = 0
var maxMP = 0
var MP = 0
var power = 0
var defense = 0
var magic = 0
var magicDefense = 0
var attacks = []
enum aiType {RANDOM, SMART, PLAYER}
var ai = aiType.RANDOM
