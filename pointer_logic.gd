## PointerLogic autoload
extends Node2D

## I mean TBH this should probably just handle clicking too


var space:PhysicsDirectSpaceState2D
#var modal_space:PhysicsDirectSpaceState2D
var parameters:PhysicsPointQueryParameters2D
var current_gamefield_collisions:Array[Dictionary]
		
var hovered_area:Area2D:
	set(value):
		if hovered_area == value: return
		hovered_area = value
		SignalBus.hovered_area_updated.emit(value)

enum HoverType {
	card,
	other,
	nothing
}

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
	var other_areas:Array[Area2D]
	
	for collision_result:Dictionary in current_gamefield_collisions:
		#print(collision_result.collider) ## this is an Area2D
		
		if not collision_result.collider.is_visible_in_tree() :continue
		
		if collision_result.collider is CardArea:
			card_areas.push_back(collision_result.collider as CardArea)
		else:
			other_areas.push_back(collision_result.collider as Area2D)
		
	
	card_areas.sort_custom(func (a:CardArea, b:CardArea) -> bool:
		return a.card.z_index + a.card.get_index() > b.card.z_index + b.card.get_index()
	)
	
	## NOTE:
	## we can either be hovering a card (cards can overlap),
	## something else like a plate,
	## or nothing
	var hover_type:HoverType = HoverType.nothing
	if card_areas.size() > 0:
		hovered_area = card_areas[0]
		hover_type = HoverType.card
	elif other_areas.size() > 0:
		pass
	else:
		hovered_area = null
		hover_type = HoverType.nothing
	
	## act depending on the hovered area I guess
	if Input.is_action_just_pressed("mouse_left"):
		print("huh")
		match hover_type:
			HoverType.nothing:
				GameState.card_choosing_side = null
			HoverType.card:
				if not GameState.card_choosing_side:
					GameState.card_choosing_side = (hovered_area as CardArea).card
				else:
					## could be playing a card on another card (or on self)
					GameState.card_choosing_side = null
				
				
			HoverType.other:
				if GameState.card_choosing_side:
					print("playing card on ")
					## GameState.play_card(GameState.card_choosing_side, TODO_DETERMINE_SIDE)
					pass
					
				
			
