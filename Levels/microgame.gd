class_name Microgame
extends Control

@export var game_name: String

signal game_won() #Emitted when the game has been won
signal game_lost() #Emitted when the game is lost
