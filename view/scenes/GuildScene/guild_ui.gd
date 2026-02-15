extends Control


signal start_run

var snapshot = {
	"hp" = 10,
	"money" = 100,
	"food" = 100,
}

@onready var hp_value_label: Label = $HBoxContainer/BoxContainer/HBoxContainer/HpValueLabel
@onready var money_value_label: Label = $HBoxContainer/VBoxContainer/HBoxContainer/MoneyValueLabel
@onready var food_value_label: Label = $HBoxContainer/VBoxContainer/HBoxContainer2/FoodValueLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hp_value_label.text = str(snapshot.hp)
	money_value_label.text = str(snapshot.money)
	food_value_label.text = str(snapshot.food)


func _on_start_run_pressed() -> void:
	start_run.emit()
