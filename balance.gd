extends Label

func _ready() -> void:
	SignalBus.balance_changed.connect(_on_balance_changed)
	
func _on_balance_changed(balance:int) -> void:
	var plus_str:String = "+" if balance > 0 else ""
	text = "Balance:\n" + plus_str + str(balance)
