extends Control


signal start_run

var snapshot = {
	"hp" = 10,
	"money" = 100,
	"wood" = 100,
	"stone" = 100
}

@onready var hp_value_label: Label = $HBoxContainer/BoxContainer/HBoxContainer/HpValueLabel
@onready var wood_value_label: Label = $HBoxContainer/VBoxContainer/HBoxContainer/WoodValueLabel
@onready var stone_value_label: Label = $HBoxContainer/VBoxContainer/HBoxContainer2/StoneValueLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hp_value_label.text = str(snapshot.hp)
	wood_value_label.text = str(snapshot.wood)
	stone_value_label.text = str(snapshot.stone)


func _on_start_run_pressed() -> void:
	start_run.emit()
