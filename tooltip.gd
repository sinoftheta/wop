extends Node2D

func _ready() -> void:
	visible = false
	#SignalBus.hovered_area_updated.connect(_on_hovered_area_updated)
	pass
	
func _process(delta: float) -> void:
	var area:Area2D = PointerLogic.hovered_area
	if not area:
		visible = false
		return
	visible = true
	
	if area is CardArea:
		position = (area as CardArea).card.handle_position + Vector2(0,-120)
		#position = lerp(position, (area as CardArea).card.handle_position + Vector2(0,-120), 0.5)
	elif area is ItemArea:
		position = (area as ItemArea).item.global_position + Vector2(0,-80)
	else:
		visible = false
		return
	
#func _on_hovered_area_updated(area:Area2D) -> void:
	#if not area:
		#visible = false
		#return
	#visible = true
	#
	#if area is CardArea:
		#position = (area as CardArea).card.handle_position
	#elif area is ItemArea:
		#position = (area as ItemArea).item.global_position
	#else:
		#visible = false
		#return
