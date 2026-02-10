extends Control


@export var logic : GuildController
@export var max_npcs_selected := 2

var selected_npcs_count := 0

var run_scene: PackedScene = Routes.get_route("run_scene")

var selected_npcs := []
var available_npcs := []

var buttons := {}

var npcs_sprites := {
	0: preload("uid://bohtq6f4si33e"),
	1: preload("uid://c6x6jf646gnjw"),
	2: preload("uid://ckvd0463qppl"),
	3: preload("uid://b17qdvevi3aao"),
	4: preload("uid://c0xtumgff7f8w")
}

var model_button_settings = {
	"toggle_mode" = true,
	"custom_minimum_size" = Vector2(160, 0),
	"size_flags_horizontal" = Button.SIZE_FILL,
	"size_flags_vertical" = Button.SIZE_FILL,
	"theme_override_styles_normal" = preload("uid://ut7fn6457uqd"),
	"theme_override_styles_pressed" = preload("uid://cougiaikoix52"),
	"theme_override_styles_hover" = preload("uid://cy2fjb7rfkc6c")
}


@onready var model_npc_button: Button = %ModelNpcButton
@onready var start_buttton = "$Panel/Panel/VBoxContainer/Panel2/Start"
@onready var npcs_buttons_container: HBoxContainer = %NpcsButtonsContainer


func _on_npc_button_pressed(pressed_button: Button) -> void:
	if pressed_button.button_pressed:
		add_npc(pressed_button.get_meta("npc"))
	else:
		remove_npc(pressed_button.get_meta("npc"))

func _on_start_button_pressed() -> void:
	logic.build_run_config(selected_npcs)
	start_run()


func _ready() -> void:
	if logic == null:
		logic = GuildController.new()
	available_npcs = logic.get_npcs_on_guild()
	generate_buttons()

func get_npc_sprite(id):
	return npcs_sprites.get(id)

func generate_buttons():
	for npc in available_npcs:
		var npc_button = get_npc_button_model()
		var key = npc.id
		
		var label: Label = npc_button.get_node("VBoxContainer/Label")
		var texture_rect: TextureRect = npc_button.get_node("VBoxContainer/TextureRect")

		label.text = npc.name
		texture_rect.texture = get_npc_sprite(key)
		npc_button.set_meta("npc", key)
		
		buttons.get_or_add(key, npc_button)
		
		npcs_buttons_container.add_child(npc_button)
		npc_button.pressed.connect(_on_npc_button_pressed.bind(npc_button))

func get_npc_button_model() -> Button:
	var npc_button = model_npc_button.duplicate()
	npc_button.show()
	return npc_button

func add_npc(npc_id):
	if selected_npcs_count >= max_npcs_selected:
		selected_npcs_count -= 1
		buttons.get(selected_npcs.pop_front()).button_pressed = false
	selected_npcs.append(npc_id)
	selected_npcs_count += 1

func remove_npc(npc_id):
	selected_npcs_count -= 1
	buttons.get(npc_id).button_pressed = false
	selected_npcs.erase(npc_id)


func start_run():
	if selected_npcs_count > 0:
		get_tree().change_scene_to_file(run_scene.resource_path)
