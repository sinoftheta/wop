## GameState autoload
extends Node


## what if you combine turns and rounds... yeah woah that might be dope??
## simpler = better

## pure logic

var points:int

var hand_size:int
var money:int

var level:int

var max_turns:int
var turns:int

var max_energy:int
var energy:int

var shop_reroll_price:int


func item_column(side:Constants.Side,index:int) -> Array[Item]:
	match side:
		Constants.Side.left:
			match index:
				0:return left_plate_col_0
				1:return left_plate_col_1
				2:return left_plate_col_2
		Constants.Side.right:
			match index:
				0:return right_plate_col_0
				1:return right_plate_col_1
				2:return right_plate_col_2
	assert(false, "invalid column")
	return []
var left_plate_col_0:Array[Item] ## left column
var left_plate_col_1:Array[Item] ## middle column
var left_plate_col_2:Array[Item] ## right column

var right_plate_col_0:Array[Item]
var right_plate_col_1:Array[Item]
var right_plate_col_2:Array[Item]



#var cards_in_party:Array[Card]
var cards_in_draw_pile:Array
var cards_in_hand:Array
var cards_in_discard_pile:Array

## animation/player input/other stuff

## replace this/put this in an InputState autoload or variable?
## maybe it should be a stack instead of a single state?
var card_choosing_side:Card:
	set(card):
		if card_choosing_side == card: return
		card_choosing_side = card
		SignalBus.card_choosing_side_updated.emit(card)

## UHHH man lol
func update_balance() -> int:
	return 0

func play_card(card:Card, side:Constants.Side) -> void:
	prints("playing", card, "on", Constants.Side.keys()[side])
	
	## animate put card on scale
	
	## animate balance change
	SignalBus.balance_changed.emit(0)
	
	
	
