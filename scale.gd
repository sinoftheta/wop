## extends Scale?????
extends Node2D


## In reality resonant frequency depends on an objects mass
## try animating SOD.f depending on the scales net weight

func _ready() -> void:
	SignalBus.balance_changed.connect(_on_balance_changed)

func _on_balance_changed(balance:int) -> void:
	animated_balance = -balance
	delta_balance_impulse = -3
	target_resonant_frequency = 5.0

## old
#func animate_balance(delta_balance:int, net_weight:int) -> void:
	#animated_balance += delta_balance
	#delta_balance_impulse = -delta_balance * 3
	#target_resonant_frequency = 1.0 / (absf(net_weight) + 5.0)
	

var animated_balance:int

var steady_state_angle:float
var delta_balance_impulse:float
var target_resonant_frequency:float
var resonant_frequency:float

var angle:float

const PLATE_WIDTH:float = 150
func _process(delta: float) -> void:
	## hmm I need like a steady state angle ~arctan(balance)
	## and a balance_change_resonance_angle(delta_balance)
	## AND a sway term thats just a sinusoid
	
	steady_state_angle = lerpf(steady_state_angle, 0.2 * 2.0 * atan(animated_balance * 0.2) / PI, delta * 3)
	#(%SOD as SOD).f = resonant_frequency ## this kills the scale
	
	## update angle
	angle = steady_state_angle + (%SOD as SOD).update(delta, 0, delta_balance_impulse) * 10
	
	%Bar.rotation = angle
	
	%RightPlate.position = Vector2.RIGHT.rotated(angle) * PLATE_WIDTH * 0.5
	%LeftPlate.position  = Vector2.LEFT .rotated(angle) * PLATE_WIDTH * 0.5
	#(%LeftPlatePile as PlatePile).pinned_point_offset = %LeftPlate.position + Vector2(0, 20)
	
	delta_balance_impulse *= 0.5
