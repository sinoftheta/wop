class_name Arrow extends Node2D

## one of these is start, one is end, and one is control
@export var p0:Vector2 ## start point
var p1:Vector2 ## control point
var p2:Vector2 ## end point

## quadratic bezier curve
## https://en.wikipedia.org/wiki/B%C3%A9zier_curve
func _process(_delta: float) -> void:
	
	p0 = Vector2.ZERO ## TODO: make this the position of the selected card
	p2 = get_global_mouse_position()
	
	p1.y = (p2.y - p0.y) * 2.0 ## control is vertically (proportinally) above end point
	p1.x = (p2.x - p0.x) * 0.5 ## control is horizontally at the midpoint of start and end
	
	
	for i:int in get_child_count():
		var t:float = float(i)/float(get_child_count()-1)
		var b_t:Vector2  = (1-t)*(1-t)*p0 + 2*(1-t)*t*p1 + t*t*p2 ## function aka position
		var db_t:Vector2 = 2*(1-t)*(p1-p0) + 2*t*(p2-p1) ## first derivative aka tangent
		var part:Sprite2D = get_child(i)
		part.modulate = lerp(Color.ROYAL_BLUE, Color.AQUA, t)
		part.scale = Vector2.ONE * 0.333 * (2.0 + t)
		part.position = b_t
		part.rotation = db_t.angle() + PI * 0.5
		
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
