class_name CardData extends RefCounted

 
var game_event_callbacks:Dictionary[int, Callable]

var short_title:String = "placeholder"
var title:String = "Placeholder"
var description:Callable = func (_card:Card) -> String: return "placeholder"
var variable_cost:bool = false
## var rarity:Constants.ShopRarity
## var retain:bool = false



func _init(
	_short_title:String,
	_attributes:Dictionary[String, Variant],
	_game_event_callbacks:Dictionary[int, Callable]
) -> void:
	for key:String in _attributes.keys():
		
		#assert(key in self, "Invalid CardData attribute key: \"{key}\" for CardID.{id_string}".format({"key":key, "id_string": Constants.CardID.keys()[_id]}))
		
		#assert(typeof(_attributes[key]) == typeof(get(key)), "Invalid CardData attribute value for CardID.{id_string}. The value for \"{key}\" has a type of \"{type_found}\" while it should be \"{type_need}\"".format({
		#	"id_string": Constants.CardID.keys()[_id], "type_found":type_string(typeof(_attributes[key])), "type_need": type_string(typeof(get(key))), "key":key
		#}))
		
		set(key, _attributes[key])
			
			
	
	#id = _id
	short_title = _short_title
	game_event_callbacks = _game_event_callbacks
