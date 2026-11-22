class_name Item extends Node2D


## Logic

var weight:int
## var data:ItemData

var siblings:int:
	get(): return get_parent().get_child_count()

const ITEM_HEIGHT:float = 3.0
func _process(_delta: float) -> void:
	position = Vector2(
		0, ## TODO: random (or wandering?) x offset based on index
		-get_index() * ITEM_HEIGHT ## reverse z index, lower on screen = further back
	)
