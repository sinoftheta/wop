## Cards autoload
extends Node

## short_title -> CardData
var data:Dictionary[String, CardData]
var data_raw:Array[CardData] = [
	CardData.new(
		"test",
		{ ## attributes
			
		},
		{ ## game event callbacks
			
		}
	),
	CardData.new(
		"test2",
		{ ## attributes
			
		},
		{ ## game event callbacks
			
		}
	)
]

func _ready() -> void:
	for card_data:CardData in data_raw:
		assert(not data.has(card_data.short_title), "CARD DATA ERROR: duplicate short_title \"%s\"" % card_data.short_title)
		data[card_data.short_title] = card_data
	
