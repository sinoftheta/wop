class_name SOD2 extends Node


## step response resonant frequency (hz)
@export var f:float = 6.0:
	set(val):
		f = val
		init()

## step response damping coeficent.
## z = 0 => undamped; system will oscilate infinitely & neve settle.
## 0 < z < 1 => underdamped; system will oscilate around target before settling.
## z >= 1 => system will not oscilate as it settles.
@export var z:float = 0.2:
	set(val):
		z = val
		init()
## system initial response
## r = 0 => system takes time to accelerate from rest.
## r > 0 => system acts immediately to change in x.
## r > 1 => system overshoots x.
## r < 0 => system will anticipate change in x.
@export var r:float = -2.0:
	set(val):
		r = val
		init()

func init() -> void:
	## compute constants
	k1 = z / (PI * f)
	k2 = 1 / (TAU * TAU * f * f)
	k3 = r * z / (TAU * f)
	#print("k1: %s, k2: %s, k3: %s" % [k1,k2,k3])

## state variables
var y: Vector2 ## position
var yd:Vector2 ## velocity 

## dynamics constants
var k1:float
var k2:float
var k3:float

func _ready() -> void:
	init()

## x is the input/target position
## xd is the speed of the input/target position
func update(t:float, x:Vector2, xd:Vector2) -> Vector2:
	y = y + t * yd ## integrate position by velocity
	yd = yd + t * (x + k3*xd - y - k1*yd) / k2 ## integrate velocity by acceleration
	return y
