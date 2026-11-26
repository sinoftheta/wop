class_name Arrow extends Node2D

func _ready() -> void:
	SignalBus.card_choosing_side_updated.connect(_on_card_choosing_side_updated)
	SignalBus.hovered_area_updated.connect(_on_hovered_area_updated)
	set_process(false)
	visible = false

var cur_card:Card
func _on_card_choosing_side_updated(card:Card) -> void:
	if card:
		cur_card = card
		visible = true
		set_process(true)
	else:
		cur_card = null
		visible = false
		set_process(false)


func _on_hovered_area_updated(area:Area2D) -> void:
	## check if area is our area
	if area is ScalePlateArea:
		looping_animation()
	else:
		if tween:tween.kill()
		if not visible: return
		for part:Sprite2D in get_children():
			part.scale = Vector2.ONE

var tween:Tween
const t:float = 0.075
func looping_animation() -> void:
	if tween:tween.kill()
	tween = create_tween().set_parallel(true).set_loops()
	for part:Sprite2D in get_children():
		part.scale = Vector2.ONE
		tween.tween_property(part, "scale", Vector2.ONE, t * 2.5)\
		.from(Vector2.ONE * 2.5)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_BACK)\
		.set_delay(0.25 * t * part.get_index())
	tween.tween_interval(1.0)




## one of these is start, one is end, and one is control
var p0:Vector2 ## start point
var p1:Vector2 ## control point
var p2:Vector2 ## end point

## quadratic bezier curve
## https://en.wikipedia.org/wiki/B%C3%A9zier_curve
func _process(_delta: float) -> void:
	
	p0 = cur_card.handle_position + Vector2(0, -35) ## start above card
	p2 = get_global_mouse_position() ##TODO: translate this so the point is actually on the mouse point... oh damn thats tricky??
	
	#p1.y = (p2.y - p0.y) * 1.0 ## control is vertically (proportinally) above end point
	#p1.x = (p2.x + p0.x) * 0.5 ## control is horizontally at the midpoint of start and end
	
	# anchor should tween between left and right positions
	# not quite right, pointer should point towards away from card?
	p1.y = lerpf(p1.y, p2.y + 1.0, 0.3) ## tiny bit above mouse point
	
	#p1.y = minf(p1.y, 10)
	p1.x = lerpf(p1.x, p0.x - (p2.x - p0.x) * 0.5 - sign(p2.x - p0.x) * 20, 0.3)
	
	var final_db_t:Vector2
	for i:int in get_child_count():
		var t:float = float(i)/float(get_child_count()-1)
		var b_t:Vector2  = (1-t)*(1-t)*p0 + 2*(1-t)*t*p1 + t*t*p2 ## function aka position
		var db_t:Vector2 = 2*(1-t)*(p1-p0) + 2*t*(p2-p1) ## first derivative aka tangent
		var part:Sprite2D = get_child(i)
		part.modulate = lerp(Color.ROYAL_BLUE, Color.AQUA, t)
		part.scale = Vector2.ONE * 0.333 * (2.0 + t)
		part.position = b_t
		part.rotation = db_t.angle() + PI * 0.5
		
		final_db_t = db_t
	
	position = -final_db_t.normalized() * 6.0
		
	#queue_redraw()

func DEBUG_draw() -> void:
	
	
	### draw a quadratic bezier curve with 10 points

	#for i:int in get_child_count():
		#var t:float = float(i)/float(get_child_count()-1)
		#var b_t:Vector2  = (1-t)*(1-t)*p0 + 2*(1-t)*t*p1 + t*t*p2 ## function aka position
		#var db_t:Vector2 = 2*(1-t)*(p1-p0) + 2*t*(p2-p1) ## first derivative aka tangent
		#draw_line(b_t - db_t.normalized() * 5, b_t + db_t.normalized() * 5, Color.GREEN, 2)
		#draw_circle(b_t, 1.0, Color.WHITE)
	
	draw_circle(p0,2, Color.RED)
	draw_circle(p1,2, Color.GREEN)
	draw_circle(p2,2, Color.BLUE)
