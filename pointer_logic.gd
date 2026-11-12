## PointerLogic autoload
extends Node2D


var space:PhysicsDirectSpaceState2D
#var modal_space:PhysicsDirectSpaceState2D
var parameters:PhysicsPointQueryParameters2D
var current_gamefield_collisions:Array[Dictionary]

##NOTE this value is modified by Card.dragged's setter
## used as a lockout for any tooltip being opened in tooltip.gd
#var card_dragged:Card:
	#set(value):
		#card_dragged = value
		#if value:
			#SignalBus.card_drag_started.emit(value)
		#else:
			#SignalBus.card_drag_ended.emit()
			
		
var hovered_area:Area2D:
	set(value):
		if hovered_area == value: return
		hovered_area = value
		SignalBus.hovered_area_updated.emit(value)

func _ready() -> void:
	space = PhysicsServer2D.space_get_direct_state(get_world_2d().get_space())
	parameters = PhysicsPointQueryParameters2D.new()
	parameters.collide_with_areas = true
	parameters.collide_with_bodies = false
	parameters.collision_mask = 1
	parameters.canvas_instance_id = 0 ## 0 is the default canvas layer
	#parameters.canvas_instance_id = %CanvasLayer.get_instance_id() ## holy fucking shit
	
	
func _physics_process(delta:float) -> void:
	parameters.position = get_global_mouse_position()
	current_gamefield_collisions = space.intersect_point(parameters)
	
	var card_areas:Array[CardArea]
	
	for collision_result:Dictionary in current_gamefield_collisions:
		print(collision_result.collider) ## this is an Area2D
		
		if not collision_result.collider.is_visible_in_tree() :continue
		card_areas.push_back(collision_result.collider as CardArea)
	
	card_areas.sort_custom(func (a:CardArea, b:CardArea) -> bool:
		return a.card.z_index + a.card.get_index() > b.card.z_index + b.card.get_index()
	)
	
	if card_areas.size() > 0:
		hovered_area = card_areas[0]
	else:
		hovered_area = null
