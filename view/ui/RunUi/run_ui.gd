extends Control

@onready var h_box_container: HBoxContainer = $HBoxContainer

var run_config = RunConfigSnapshot.new()
var selected_npcs : Array

var npcs_sprites := {
	0: preload("uid://bohtq6f4si33e"),
	1: preload("uid://c6x6jf646gnjw"),
	2: preload("uid://ckvd0463qppl"),
	3: preload("uid://b17qdvevi3aao"),
	4: preload("uid://c0xtumgff7f8w")
}


func _ready() -> void:
	selected_npcs = run_config.get_RunConfig_snapshot()
	
	for i in selected_npcs:
		var texture = TextureRect.new()
		texture.texture = get_npc_sprites(i.get("id"))
		texture.expand_mode = TextureRect.EXPAND_FIT_WIDTH
		h_box_container.add_child(texture)

func set_run_config(rc: RunConfigSnapshot):
	run_config = rc

func get_npc_sprites(id: int):
	return npcs_sprites.get(id)
