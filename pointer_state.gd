## PointerState autoload
extends Node2D ## needs to be Node2D so we can access get_world_2d()


## CanvasLayers that will be scanned for each menu
## the default layer will always be scanned
## treat as Dictionary[Constants.Menu,Array[CanvasLayer]]
#var canvases_on_menu:Dictionary[Constants.Menu,Array] 


var choosing_scale_side:bool


var space:PhysicsDirectSpaceState2D
#var modal_space:PhysicsDirectSpaceState2D
var parameters:PhysicsPointQueryParameters2D
var current_gamefield_collisions:Array[Dictionary]


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
	
	## if there are ANY VISIBLE cards, they take hover priority over static stuff 
	

	#var card_tt_hitboxes:Array[TooltipHitbox]
	#var non_card_tt_hitboxes:Array[TooltipHitbox]
	#
	#
	#for collision_result:Dictionary in current_gamefield_collisions:
		#var collider:TooltipHitbox = collision_result.collider
		#
		#if not collider.is_visible_in_tree(): continue
		#
		#if collider.tooltip_type == Constants.TooltipType.card:
			#var card:Card = collider.card
			### NOTE: can also just filter by CardZone.id here!
			### TODO: bring back a bit of the old post collision loop filtering, it worked well
			#if  (not card.at_destination) or\
				#(card.animated_face_up < 0.5):
				#continue
			#
			#card_tt_hitboxes.push_back(collider)
		#else:
			#non_card_tt_hitboxes.push_back(collider)
	#
	#card_tt_hitboxes.sort_custom(func (a:TooltipHitbox,b:TooltipHitbox) -> bool:
		### UUUhhhhhhhh I hope this is right lmao
		#return a.card.z_index + a.card.get_index() > b.card.z_index + b.card.get_index()
	#)
	#
#
	#if card_tt_hitboxes.size() > 0:
		##var top_card:Card = card_tt_hitboxes[0].card
		#
		### TODO: do filtering based on topmost card here
		#
		#hovered_hitbox = card_tt_hitboxes[0]
	#elif non_card_tt_hitboxes.size() > 0:
		#hovered_hitbox = non_card_tt_hitboxes[0]
	#else:
		#hovered_hitbox = null
	
