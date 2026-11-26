class_name Item extends Node2D


## Logic

var weight:int
## var data:ItemData

var siblings:int:
	get(): return get_parent().get_child_count()

var hovered:bool:
	set(val):
		if hovered == val: return
		hovered = val
		if hovered:
			%Sprite.scale = Vector2.ONE * 1.1
			z_index = 1
		else:
			%Sprite.scale = Vector2.ONE
			z_index = 0

func _ready() -> void:
	SignalBus.hovered_area_updated.connect(_on_hovered_area_updated)

func _on_hovered_area_updated(area:Area2D) -> void:
	hovered = %Area2D == area

const ITEM_HEIGHT:float = 5#3.0
func _process(_delta: float) -> void:
	position = Vector2(
		0, ## TODO: random (or wandering?) x offset based on index
		-get_index() * ITEM_HEIGHT ## reverse z index, lower on screen = further back
	)
