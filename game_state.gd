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

## DEBUG
func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("ui_accept"): ## enter, space
		var smallest_zone:ItemZone
		for zone:ItemZone in item_zones:
			
			
			if not smallest_zone and zone.get_child_count() > 0:
				smallest_zone = zone
			
			## disregard
			if zone.get_child_count() == 0: continue
			
			## if new smallest, update
			if zone.get_child_count() < smallest_zone.get_child_count():
				smallest_zone = zone
			
				
		if smallest_zone:
			var item_to_remove:Item = smallest_zone.get_child(0)
			smallest_zone.remove_child(item_to_remove)
			item_to_remove.queue_free()
			
		var balance:int = weight_on_plate(Constants.Side.left) - weight_on_plate(Constants.Side.right)
		SignalBus.balance_changed.emit(
			balance
		)
		


#party_zone
#exhaust_zone
var draw_zone:CardZone
var hand_zone:CardZone
var discard_zone:CardZone

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



func next_free_column(side:Constants.Side) -> int:
	
	var s:int = 0 if side == Constants.Side.left else 3
	## smallest of the 3 columns with middle -> left -> right as the precident
	
	var count_0:int = item_zones[s + 0].get_child_count()
	var count_1:int = item_zones[s + 1].get_child_count()
	var count_2:int = item_zones[s + 2].get_child_count()
	
	if count_0 <= count_1 and count_0 <= count_2:
		print("condition a")
		return 0
	if count_1 <= count_2:
		return 1
	return 2
	#if count_1 <= count_2:
	#	return 1
	#return 2
	
func weight_on_plate(side:Constants.Side) -> int:
	var r:Array = range(0,3) if side == Constants.Side.left else range(3,6)
	
	print(r)
	var total:int = 0
	for i:int in r:
		for item:Item in item_zones[i].get_children():
			total += item.weight
	
	return total
	
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
	
	var balance:int = weight_on_plate(Constants.Side.left) - weight_on_plate(Constants.Side.right)
	SignalBus.balance_changed.emit(
		balance
	)
	
	card.get_parent().remove_child(card)
	card.queue_free()
	
	
func input_redraw() -> void:
	pass

func input_clear_scale() -> void:
	pass
