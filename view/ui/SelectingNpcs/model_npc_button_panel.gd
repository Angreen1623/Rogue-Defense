extends Panel

enum ColorPatterns {purple, beige}
@export var current_color : ColorPatterns

var purple_pattern = preload("uid://ccwoqfbe535jq")
var beige_pattern = preload("uid://irhmjjusl6d3")

func _enter_tree() -> void:
	apply_color()

func apply_color():
	print_debug("[SelectingNpcs] Cor padrão atual: %s" % str(current_color))
	
	remove_theme_stylebox_override("normal")

	if current_color == ColorPatterns.purple:
		add_theme_stylebox_override("normal", purple_pattern)
	elif current_color == ColorPatterns.beige:
		add_theme_stylebox_override("normal", beige_pattern)
