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


var cards_in_party:Array
var cards_on_left_plate:Array
var cards_on_right_plate:Array
var cards_in_draw_pile:Array
var cards_in_hand:Array
var cards_in_discard_pile:Array

## animation/player input/other stuff

## replace this/put this in an InputState autoload or variable?
## maybe it should be a stack instead of a single state?
var card_choosing_side:Card:
	set(card):
		card_choosing_side = card
		SignalBus.card_choosing_side_updated.emit(card)


#func play_card(_side:bool) -> void:
	#pass
