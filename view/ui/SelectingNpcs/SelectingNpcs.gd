extends Control

## ============================================================================
## INTERFACE: SelectingNpcs (Tela de Selecao de Personagens)
## ============================================================================
## 
## DESCRICAO:
## Permite ao jogador escolher quais NPCs (Torres/Herois) levar para a partida.
## Gerencia a lista de selecionados e inicia a cena do jogo (RunScene).
## ============================================================================

@export var logic : GuildController # Controlador logico (se existir)
@export var max_npcs_selected := 2  # Limite de personagens

var selected_npcs_count := 0
var run_scene: PackedScene = Routes.get_route("run_scene")

var selected_npcs := []
var available_npcs := []
var buttons := {} # Mapa de ID -> Botao

# Recursos visuais (Icones)
var npcs_sprites := {
	0: preload("uid://bohtq6f4si33e"),
	1: preload("uid://c6x6jf646gnjw"),
	2: preload("uid://ckvd0463qppl"),
	3: preload("uid://b17qdvevi3aao"),
	4: preload("uid://c0xtumgff7f8w")
}

@onready var model_npc_button_panel: Panel = %ModelNpcButtonPanel
@onready var start_buttton = "$Panel/Panel/VBoxContainer/Panel2/Start"
@onready var npcs_buttons_container: HBoxContainer = %NpcsButtonsContainer


func _ready() -> void:
	# Se nao foi injetado, cria um novo controller (Padrao MVC/Dependency Injection)
	if logic == null:
		logic = GuildController.new()
		
	available_npcs = logic.get_npcs_on_guild()
	print_debug("[SelectingNpcs] NPCs disponiveis para selecao: %d" % available_npcs.size())
	
	generate_buttons()


## Chamado quando clica em um botao de NPC (Toggle).
func _on_npc_button_pressed(pressed_button: Button) -> void:
	var npc_id = pressed_button.get_meta("npc")
	
	if pressed_button.button_pressed:
		print_debug("[SelectingNpcs] Selecionou NPC ID: %s" % str(npc_id))
		add_npc(npc_id)
	else:
		print_debug("[SelectingNpcs] Removeu NPC ID: %s" % str(npc_id))
		remove_npc(npc_id)


## Inicia a partida.
func _on_start_button_pressed() -> void:
	print_debug("[SelectingNpcs] Tentando iniciar partida com %d personagens..." % selected_npcs.size())
	if selected_npcs.size() > 0:
		# Passa a lista escolhida para o Controller montar a config
		logic.build_run_config(selected_npcs)
		start_run()
	else:
		print_debug("[SelectingNpcs] AVISO: Nenhum personagem selecionado!")


func generate_buttons():
	var i := 0
	for npc in available_npcs:
		var npc_button_panel = get_npc_button_model(i)
		var npc_button = npc_button_panel.get_node("VBoxContainer/VBoxContainer2/SelectNpcButton") 
		var key = npc.id
		
		i +=1
		
		var npc_name: Label = npc_button_panel.get_node("VBoxContainer/VBoxContainer/NpcName")
		var npc_sprite: TextureRect = npc_button_panel.get_node("VBoxContainer/VBoxContainer/Panel/NpcSprite")
		
		npc_name.text = npc.name
		npc_sprite.texture = get_npc_sprite(key)
		
		# Guarda o ID no metadata do botao para recuperar depois
		npc_button.set_meta("npc", key)
		
		buttons.get_or_add(key, npc_button)
		npcs_buttons_container.add_child(npc_button_panel)
		
		# Conecta o sinal 'pressed' passando o proprio botao como argumento (bind)
		npc_button.pressed.connect(_on_npc_button_pressed.bind(npc_button))


func get_npc_sprite(id):
	return npcs_sprites.get(id)


func get_npc_button_model(i: int) -> Panel:
	var npc_button_container : Panel
	
	if i % 2 == 0:
		model_npc_button_panel.current_color = 0
	else:
		model_npc_button_panel.current_color = 1
	
	npc_button_container = model_npc_button_panel.duplicate()
	
	npc_button_container.show()
	return npc_button_container


## Adiciona a lista e remove o mais antigo se passar do limite.
func add_npc(npc_id):
	if selected_npcs_count >= max_npcs_selected:
		# Remove o primeiro da fila (FIFO)
		var removed_id = selected_npcs.pop_front()
		selected_npcs_count -= 1
		# Desmarca o botao visualmente
		if buttons.has(removed_id):
			buttons.get(removed_id).button_pressed = false
		print_debug("[SelectingNpcs] Limite atingido. Removendo antigo ID: %s" % str(removed_id))

	selected_npcs.append(npc_id)
	selected_npcs_count += 1


func remove_npc(npc_id):
	selected_npcs_count -= 1
	if buttons.has(npc_id):
		buttons.get(npc_id).button_pressed = false
	selected_npcs.erase(npc_id)


func start_run():
	if selected_npcs_count > 0:
		var path = run_scene.resource_path
		print_debug("[SelectingNpcs] Mudando para cena: %s" % path)
		get_tree().change_scene_to_file(path)
