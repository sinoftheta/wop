extends Node

signal balance_changed(balance:int)
signal money_changed(money:int)
signal level_changed(level:int)
signal tokens_changed(tokens:int)
signal round_changed(round:int)
signal max_round_changed(max_round:int)
signal energy_changed(energy:int)
signal remaining_turns_changed(remaining_turns:int)

signal hovered_area_updated(area:Area2D)
signal card_choosing_side_updated(card:Card) ## can be null
