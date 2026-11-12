class_name CardArea extends Area2D
var card:Card
func _ready() -> void:
	card = get_parent().get_parent()
