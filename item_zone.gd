class_name ItemZone
extends Node2D

@export var side:Constants.Side
@export var column_number:int

func _ready() -> void:
	## resgister self in GameState
	GameState.item_zones.push_back(self)
