class_name Card
extends Node2D

var selected:bool
var hovered:bool

func anchor_positoin() -> void:
	pass

func _process(_delta: float) -> void:
	
	## move Handle towards position
	%Handle.global_position = lerp(%Handle.global_position, get_parent().global_position, 0.5)
