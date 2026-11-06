## GameState autoload
extends Node


## pure logic
var hand_size:int
var tokens:int
var money:int

var game_round:int
var level:int

var max_turns:int
var turns:int

var max_energy:int
var energy:int

var shop_reroll_price:int

var cards_on_left_plate:Array
var cards_on_right_plate:Array
var cards_in_draw_pile:Array
var cards_in_hand:Array
var cards_in_discard_pile:Array

## animation/player input/other stuff
var card_choosing_side:Card:
	set(card):
		card_choosing_side = card
		SignalBus.card_choosing_side_updated.emit(card)


#func play_card(_side:bool) -> void:
	#pass
