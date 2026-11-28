class_name ItemZone
extends Node2D

@export var side:Constants.Side
@export var column_number:int
var rank:int:
	get():return column_number + (0 if side == Constants.Side.left else 3)

func _ready() -> void:
	## resgister self in GameState
	GameState.item_zones.push_back(self)
	
	## sort the whole thing each time fuck it who cares we all die one day
	GameState.item_zones.sort_custom(func (a:ItemZone,b:ItemZone) -> bool:
		return a.rank < b.rank
	)
	if GameState.item_zones.size() == 6:
		for zone:ItemZone in GameState.item_zones:
			print(zone.rank)
