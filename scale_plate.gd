extends Node2D

## not even sure if we need this?

@export var side:Constants.Side

func _ready() -> void:
	SignalBus.hovered_area_updated.connect(_on_hovered_area_updated)
	SignalBus.card_choosing_side_updated.connect(_on_card_choosing_side_updated) ## can be null
	visible = false
	pass

func _on_card_choosing_side_updated(card:Card) -> void:
	if card:
		visible = true
		## animate appear, delay based on side
	else:
		visible = false

func _on_hovered_area_updated(area:Area2D) -> void:
	## check if area is our area
	if area == %Area:
		## enter hovered state
		%ZoneOutline.scale = Vector2.ONE * 1.1
	else:
		## exit hovered state
		%ZoneOutline.scale = Vector2.ONE
