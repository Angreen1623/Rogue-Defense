extends Panel

enum ColorPatterns {purple, beige}
@export var current_color : ColorPatterns

@onready var npc_name: Label = $VBoxContainer/VBoxContainer/NpcName

var purple_pattern = preload("uid://ccwoqfbe535jq")
var beige_pattern = preload("uid://irhmjjusl6d3")

func _enter_tree() -> void:
	await ready
	apply_color()

func apply_color():
	print_debug("[SelectingNpcs] Cor padrão atual: %s" % str(current_color))
	
	remove_theme_stylebox_override("panel")

	if current_color == ColorPatterns.purple:
		add_theme_stylebox_override("panel", purple_pattern)
		npc_name.add_theme_color_override("font_color", Color(255,255,255))
	elif current_color == ColorPatterns.beige:
		add_theme_stylebox_override("panel", beige_pattern)
		npc_name.add_theme_color_override("font_color", Color(0,0,0))
