class_name CardZone
extends Node2D

#@export var contents_seek_destination:bool = true
#@export var contents_draggable:bool
#@export var contents_selectable:bool

## distance between cards. Cards will not go past the zone's length, meaning
## this value will be "crushed" and ignored when (N-1) * card_padding > length
## where N is the number of cards in the zone. 
@export var card_padding:float = 70
@export_range(0,359) var angle:float = 270:
	set(value):
		angle = value
var b_hat:Vector2:
	get():return Vector2(sin(deg_to_rad(angle)), cos(deg_to_rad(angle)))

@export var reverse_select_direction:bool
var selection_dir:float:
	get():return -1.0 if reverse_select_direction else 1.0
@export var length:float = 1.0:
	set(value):
		length = value
		queue_redraw()

var frozen:bool = false

func _ready() -> void:
	pass
	#SignalBus.menu_updated.connect(_on_menu_updated)
	
	
	#match id:
	#	Constants.CardZoneID.display:
	#		return
	#GameLogic.card_zones[id] = self
	
	
func clear_children() -> void:
	for card:Card in get_children():
		remove_child(card)
		card.queue_free()


func __draw() -> void:
	pass
	#var color:Color
	#match id:
			#Constants.CardZoneID.display:
				#color = Color.WHITE
			#Constants.CardZoneID.deck:
				#color = Color.BLUE_VIOLET
			#Constants.CardZoneID.hand:
				#color = Color.AQUA
			#Constants.CardZoneID.act:
				#color = Color.RED
			#Constants.CardZoneID.discard:
				#color = Color.CHARTREUSE
			#Constants.CardZoneID.shop:
				#color = Color.HOT_PINK
			#Constants.CardZoneID.party:
				#color = Color.BURLYWOOD
