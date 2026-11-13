class_name Card
extends Node2D

## game logical state

## other stuff

const SPEED_LIMIT:float = 2000
const ACCELERATION:float = 32#16
const ROTATION_SPEED:float = 5 ## needs a max angle, but the math is fine 
const DESTINATION_THRESHOLD_SQ:float = 4

func _ready() -> void:
	SignalBus.card_choosing_side_updated.connect(_on_card_choosing_side_updated)
	SignalBus.hovered_area_updated      .connect(_on_hovered_area_updated)

var selected:bool:
	set(val):
		selected = val
		%Handle.z_index = 1 if selected else 0

var hover_tween:Tween
var hovered:bool:
	set(val):
		if hovered == val:return
		hovered = val
		
		if hover_tween: hover_tween.kill()
		hover_tween = create_tween().set_parallel()
		const t:float = 0.16
		if hovered:
			hover_tween.tween_property(%HoverTX, "scale", Vector2.ONE * 1.1, t)\
			.set_ease(Tween.EASE_OUT)\
			.set_trans(Tween.TRANS_ELASTIC)
			%HoverTX.z_index = 2
		else:
			hover_tween.tween_property(%HoverTX, "scale", Vector2.ONE, t)\
			.set_ease(Tween.EASE_OUT)\
			.set_trans(Tween.TRANS_ELASTIC)
			%HoverTX.modulate = Color.WHITE
			%HoverTX.z_index = 0

#var dragged:bool

## exposed for stuff
var handle_position:Vector2:
	get(): return %Handle.global_position
	set(val): %Handle.global_position = val
var at_destination:bool
	
## used internally
var zone:CardZone:
	get(): return get_parent()
var sibling_count:int:
	get(): return get_parent().get_child_count()
var interaction_size:Vector2:
	get(): return (%CollisionShape.shape as RectangleShape2D).size


## returns the current padding as a ratio of zone.legth
## the sum of all card paddings will not exceed 1.0,
## meaning anchors will never be outside their zone
func crushed_padding_ratio() -> float:
	if zone.card_padding * (sibling_count - 1) > zone.length:
		return 1.0 / (sibling_count - 1)
	else:
		return zone.card_padding / zone.length
func zone_anchor_position() -> Vector2:
	
	var i:int = get_index()
	
	var w:float = crushed_padding_ratio()
	
	## anchor point of the card "p" as a length on the zone line
	## anchors cluster around the center of the zone with a padding w
	var p:float =  - (i - ((sibling_count - 1) * 0.5)) * w * zone.length * global_scale.x
	
	return zone.b_hat * p

func _process(delta: float) -> void:
	update_faux_3d(delta)
	
	var selected_offset:Vector2 = zone.b_hat.orthogonal() * -5.0 if selected else Vector2.ZERO
	var render_destination:Vector2 = zone_anchor_position() + zone.position + selected_offset
	
	## this I could make into a SOD
	var next_position:Vector2 = lerp(
		%Handle.position, 
		render_destination,
		minf(delta * ACCELERATION * (0.0 if zone.frozen else 1.0),1.0)
	)
	var dp:Vector2 = (next_position - %Handle.position).limit_length(delta * SPEED_LIMIT)
	%Handle.position += dp
	#var sd:float = (1.0 if zone.contents_seek_destination else 0.0)
	#destination_travel_time += delta * sd
	
	## rotate dp by 90deg if destination_travel_time = 0, and approach 0deg as destination_travel_time -> inf
	#_Render.position += dp.rotated(orbit / (1.0 + destination_travel_time)) * sd
	
	#var distance_to_destination:float = _Render.position.distance_squared_to(render_destination)
	#at_destination = distance_to_destination < DESTINATION_THRESHOLD_SQ
	



var hover_point:Vector2


## TODO: I guess I could connect & disconnect these signals as the cards enter and exit the tree idk
func _on_card_choosing_side_updated(card:Card) -> void:
	selected = card == self
func _on_hovered_area_updated(area:Area2D) -> void:
	hovered = %Area2D == area

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if not hovered: return
	
	if event is InputEventMouseMotion:
		hover_point = (event as InputEventMouseMotion).position
		
func update_faux_3d(delta:float) -> void:
	var magnitude:float = 0.01
	var bias:float = minf(1.0, delta * 20)
	if hovered:# or dragged:
		## faux 3d tilt towards mouse effect
		#var hover_f3d:float = deg_to_rad(-magnitude *\
			#sin((hover_point - 0.5 * (_Collision.shape as RectangleShape2D).size).angle() * 2)
		#)
		## scaling with the radius actually feels better
		var v:Vector2 = Vector2(
			hover_point.x / interaction_size.x,
			hover_point.y / interaction_size.y
		) * 2 - Vector2.ONE
		var hover_f3d:float = deg_to_rad(-magnitude * v.x * v.y)
		
		%Faux3DTX.skew     = lerpf(%Faux3DTX.skew,     hover_f3d,       bias)
		%Faux3DTX.rotation = lerpf(%Faux3DTX.rotation, hover_f3d * 0.5, bias)
		
		## TODO: use Vector2.lerp to make the number on the left green
		%Faux3DTX.position = lerp(%Faux3DTX.position,Vector2.ZERO,bias)
		
	else: ## we don't need this param, but we still need this block in the if/else structure.
		## idk I think that note is there just because "elif zone.contents_spread" reads better? or maybe there was another reason.
		## faux 3d idle tilt effect
		var positional_f3d:float =\
		deg_to_rad(magnitude * sin(Engine.get_frames_drawn() * 0.01 + (get_index() + zone.get_index()) * PI * 0.2))
		%Faux3DTX.skew     = lerpf(%Faux3DTX.skew,     positional_f3d,       bias) #* Options.motion
		%Faux3DTX.rotation = lerpf(%Faux3DTX.rotation, positional_f3d * 0.5, bias) #* Options.motion
		
		var sway:float = 1 * sin(Engine.get_frames_drawn() * 0.015 + (get_index() + zone.get_index() * PI) * PI * 0.8) #* Options.motion
		%Faux3DTX.position = lerp(
			%Faux3DTX.position,
			sway * zone.b_hat.orthogonal(),
			bias,
		)
