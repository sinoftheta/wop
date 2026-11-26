## GameState autoload
extends Node

var card_tscn:PackedScene = preload("res://card.tscn")
var item_tscn:PackedScene = preload("res://item.tscn")

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



var item_zones:Array[ItemZone]
func _ready() -> void:
	item_zones.sort_custom(func (a:ItemZone,b:ItemZone) -> bool:
		if a.side > b.side:
			return true
		return a.column_number > b.column_number
	)


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
		if card:
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

## UHHH man lol
func update_balance() -> int:
	return 0


func next_free_column(side:Constants.Side) -> int:
	var s:int = 0 if side == Constants.Side.left else 3
	## smallest of the 3 columns with middle -> left -> right as the precident
	
	var mid_count :int = item_zones[s + 0].get_child_count()
	var left_count  :int = item_zones[s + 1].get_child_count()
	var right_count:int = item_zones[s + 2].get_child_count()
	
	
	if mid_count <= right_count and mid_count <= left_count:
		return 0
	if left_count < right_count:
		return 1
	return 2
	
	### mid column has priority
	#if mid_count <= left_count and mid_count <= right_count:
		#return 1
	#
	### then left column
	#if left_count < mid_count and left_count <= right_count:
		#return 0
	#
	### finally right column
	#return 2
	
	

func input_play_card(card:Card, side:Constants.Side) -> void:
	
	var s:int = 0 if side == Constants.Side.left else 1
	
	## determine next column to place the item
	
	## check if have enough energy?
	
	## animate/trigger energy spent
	
	## animate/trigger put card on scale
	
	## animate/trigger balance change
	
	
	## discard card
	
	var nfc:int = next_free_column(side)
	prints("playing", card, "on", Constants.Side.keys()[side], "in column", nfc)
	## instantiate & place item on scale
	var new_item:Item = item_tscn.instantiate()
	var i:int = s * 3 + nfc
	item_zones[i].add_child(new_item)
	
	var balance:int = (
		item_zones[0].get_child_count() +
		item_zones[1].get_child_count() +
		item_zones[2].get_child_count() -
		
		item_zones[3].get_child_count() -
		item_zones[4].get_child_count() -
		item_zones[5].get_child_count()
	)
	prints("balance:",balance)
	SignalBus.balance_changed.emit(
		balance
	)
	
	card.get_parent().remove_child(card)
	card.queue_free()
	
	
func input_redraw() -> void:
	pass

func input_clear_scale() -> void:
	pass
