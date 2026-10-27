## extends Scale?????
extends Node2D


## In reality resonant frequency depends on an objects mass
## try animating SOD.f depending on the scales net weight



func animate_add_card(_card:Card, _side:Constants.Side) -> void:
	pass

func animate_balance(delta_balance:int, net_weight:int) -> void:
	animated_balance += delta_balance
	delta_balance_impulse = -delta_balance * 3
	target_resonant_frequency = 1.0 / (absf(net_weight) + 5.0)
	

var animated_balance:int

var steady_state_angle:float
var delta_balance_impulse:float
var target_resonant_frequency:float
var resonant_frequency:float

var angle:float

func _process(delta: float) -> void:
	## hmm I need like a steady state angle ~arctan(balance)
	## and a balance_change_resonance_angle(delta_balance)
	## AND a sway term thats just a sinusoid
	
	steady_state_angle = lerpf(steady_state_angle, 0.2 * 2.0 * atan(animated_balance * 0.2) / PI, delta * 3)
	resonant_frequency = lerpf(resonant_frequency, target_resonant_frequency,                     delta * 3)
	#(%SOD as SOD).f = resonant_frequency ## this kills the scale
	
	## update angle
	angle = (
		steady_state_angle + ## steady state angle
		sin(Engine.get_frames_drawn() * 0.016 * resonant_frequency) * 0.01 +
		(%SOD as SOD).update(delta, 0, delta_balance_impulse) * 10 ## 
	)
	
	%Bar.rotation = angle
	
	%RightPlate.position = Vector2.RIGHT.rotated(angle) * 50
	%LeftPlate.position  = Vector2.LEFT .rotated(angle) * 50
	
	queue_redraw()
	delta_balance_impulse *= 0.5

func _draw() -> void:
	draw_circle(Vector2.RIGHT.rotated(angle) * 50, 2, Color.RED)


func _on_debug_inc_balance_pressed() -> void:
	animate_balance(1, animated_balance + 1)
	%DebugBalanceReadout.text = str(animated_balance)

func _on_debug_dec_balance_pressed() -> void:
	animate_balance(-1, animated_balance - 1)
	%DebugBalanceReadout.text = str(animated_balance)
