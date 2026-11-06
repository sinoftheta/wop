class_name Card
extends Node2D

## game logical state

## other stuff

var selected:bool
var hovered:bool

## exposed for stuff
var handle_position:Vector2:
	get(): return %Handle.global_position

func anchor_positoin() -> void:
	pass

func _process(_delta: float) -> void:
	
	## move Handle towards position
	%Handle.global_position = lerp(
		%Handle.global_position, 
		get_parent().global_position + (Vector2(0,-20) if selected else Vector2.ZERO),
	0.5)


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		## mouse down
		if (event as InputEventMouseButton).pressed:
			pass
			selected = not selected
			if selected:
				GameState.card_choosing_side = self
			else:
				## could "remove self from value" instead of nulling it out? that might scale well idk
				GameState.card_choosing_side = null
		
		## mouse up
		else:
			pass
