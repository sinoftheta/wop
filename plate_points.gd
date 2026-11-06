class_name PlatePile extends Node2D

var _points:PackedVector2Array
var _points_init:PackedVector2Array
var _points_is_pinned:PackedByteArray # 1 = pinned, 0 = not pinned
var _prev_points:PackedVector2Array

var _edges_init_length:PackedFloat64Array
var _edges_left_index:PackedInt64Array
var _edges_right_index:PackedInt64Array


var drag:float = 0 # ?????
var gravity:Vector2 = Vector2(0.0,40.0)
var mass:float = 10.0#10.0
var elasticity:float = 0.2#0.2

const height:int = 4
const width:int = 4
const spacing:float = 15.0

## edges will 

## by default there will be 4 points in the mesh

## the 4 default points will be invisible and will
## not have a card/item/thing associated with them?


## if i'm gonna do custom top layer topologies
## the algorithm will be: pop n points, build n+1 custom points

func push_point(pinned:bool) -> void:
	
	var debug_prev_edges:int = _edges_left_index.size()
	
	var i:int = _points.size()
	var x:int = i % width
	var y:int = i / width
	
	var start_x:float = (width  - 1) * spacing * -0.5
	var start_y:float = (height - 1) * spacing * -0.5
	
	var init_p:Vector2 = Vector2(start_x + x * spacing, start_y + y * spacing * -1)
	
	## 4 different top-row configurations based on x
	match x:
		0:
			## center
			pass
		1:
			## two in the middle
			pass
		2:
			## three in the middle
			pass
		3:
			## all flat
			pass
	
	var realtime_p:Vector2
	if i == 0:
		realtime_p = init_p
	else:
		## predicting realtime_p is gonna be really tough,
		## essentially we need a lot of information about the macro structure
		## algo:
		## check difference between _points[i - 1] and _points_init[i - 1]
		## assume the difference is the same for the point we are adding
		
		## could also try and factor in rotation, more points, etc. feels
		## like an endlessly improvable algo. Also it just impossibly breaks when the structure folds in on itself
		var pdp:Vector2 = _points_init[i - 1] - _points[i - 1]
		realtime_p = init_p - pdp
	
	_points     .append(realtime_p)
	_prev_points.append(realtime_p)
	
	_points_init.append(init_p)
	
	_points_is_pinned.append(1 if pinned else 0)
	
	if x != 0:
		## create an edge between this point and its left neighbor
		
		var left_i:int = i - 1
		
		_edges_init_length.append(( _points_init[i] - _points_init[left_i] ).length())
		_edges_right_index.append(i)
		_edges_left_index.append(left_i)
		
	if y != 0:
		## create an edge between this point and its top neighbor
		var top_i:int = i - width
		
		_edges_init_length.append(( _points_init[i] - _points_init[top_i] ).length())
		_edges_right_index.append(i)
		_edges_left_index.append(top_i)
		
	
	if y != 0 and x != width - 1:
		## create an edge between this point and its top-right neighbor
		var top_right_i:int = i - width + 1
		
		_edges_init_length.append(( _points_init[i] - _points_init[top_right_i] ).length())
		_edges_right_index.append(i)
		_edges_left_index.append(top_right_i)
		
	if x != 0 and y != 0:
		## create an edge between this point and its top-left neighbor
		var top_left_i:int = i - width - 1
		
		_edges_init_length.append(( _points_init[i] - _points_init[top_left_i] ).length())
		_edges_right_index.append(i)
		_edges_left_index.append(top_left_i)
	
	print("added %d edges" % (_edges_left_index.size() - debug_prev_edges))
	
func pop_point() -> void:
	## i can be thought of as the "point index"
	var i:int = _points.size() - 1
	_points.remove_at(i)
	_points_init.remove_at(i)
	_points_is_pinned.remove_at(i)
	_prev_points.remove_at(i)
	
	## find instances of i in edges
	var edge_indicies_containing_i:Array[int]
	
	for li:int in _edges_left_index.size():
		if _edges_left_index[li] == i:
			edge_indicies_containing_i.push_back(li)
		
	for ri:int in _edges_right_index.size():
		if _edges_right_index[ri] == i:
			edge_indicies_containing_i.push_back(ri)
	
	edge_indicies_containing_i.sort()
	edge_indicies_containing_i.reverse()
	
	## remove edges associated with our point_index
	for ei:int in edge_indicies_containing_i:
		_edges_init_length.remove_at(ei)
		_edges_left_index.remove_at(ei)
		_edges_right_index.remove_at(ei)

var pinned_point_offset:Vector2 = Vector2.ZERO

func _process(delta: float) -> void:
	for i:int in _points.size():
		
		## manually move around the pinned points
		if _points_is_pinned[i]:
			## manually move around the pinned points
			_points[i] = _points_init[i] + pinned_point_offset
			continue
		
		var acceleration:Vector2 = gravity / mass
		
		## verlet integration
		var _prev:Vector2 = _points[i]
		
		_points[i] = 2 * (1.0 - drag) * _points[i] - _prev_points[i] + acceleration * (1.0 - drag) * delta * delta
		
		## keep track of prev
		_prev_points[i] = _prev
		
		## dummy window collision
		#_points[i].x = clampf(_points[i].x, -320, 320)
		#_points[i].y = clampf(_points[i].y, -180, 180)
		
	for i:int in _edges_init_length.size():
		
		var diff:Vector2 = _points[_edges_left_index [i]] - _points[_edges_right_index[i]]
		var diff_factor:float = (_edges_init_length[i] - diff.length()) * 0.5 * (1.0 - elasticity) / diff.length()
		 
		if not _points_is_pinned[_edges_left_index [i]]:
			_points[_edges_left_index [i]] += diff * diff_factor
			
		if not _points_is_pinned[_edges_right_index [i]]:
			_points[_edges_right_index[i]] -= diff * diff_factor
	
	queue_redraw()

func _draw() -> void:
	for i:int in _edges_init_length.size():
		draw_line(_points[_edges_left_index[i]], _points[_edges_right_index[i]], Color.CORAL)
	for i:int in _points.size():
		draw_circle(_points[i], 1.0, lerp(Color.BLACK, Color.ORANGE_RED, float(i)/_points.size()))

## debug
## really fun actually lol
func _input(event) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				push_point(_points.size() < width)
				
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				pop_point()
