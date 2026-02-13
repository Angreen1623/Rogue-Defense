extends Control

## ============================================================================
## INTERFACE: RunUi (Interface da Partida - Preparacao)
## ============================================================================
## 
## DESCRICAO:
## Mostra os NPCs que foram selecionados para a run.
## Cria icones dinamicamente na tela.
## ============================================================================

@onready var h_box_container: HBoxContainer = $HBoxContainer

# Instancia local ou referencia estatica? Neste caso, usamos os dados estaticos
# mas mantemos a variavel por compatibilidade com codigo existente.
var run_config = RunConfigSnapshot.new()
var selected_npcs : Array

# Mapeamento de ID de NPC -> Textura
var npcs_sprites := {
	0: preload("uid://bohtq6f4si33e"),
	1: preload("uid://c6x6jf646gnjw"),
	2: preload("uid://ckvd0463qppl"),
	3: preload("uid://b17qdvevi3aao"),
	4: preload("uid://c0xtumgff7f8w")
}


func _ready() -> void:
	# Pega os dados globais
	selected_npcs = run_config.get_RunConfig_snapshot()
	
	if selected_npcs == null:
		print_debug("[RunUi] Nenhum NPC selecionado.")
		selected_npcs = []
	else:
		print_debug("[RunUi] Exibindo %d NPCs na interface." % selected_npcs.size())
	
	for npc in selected_npcs:
		if npc is Dictionary and npc.has("id"):
			var npc_id = npc.get("id")
			
			var texture = TextureRect.new()
			texture.texture = get_npc_sprites(npc_id)
			texture.expand_mode = TextureRect.EXPAND_FIT_WIDTH
			
			h_box_container.add_child(texture)
			# print_debug("[RunUi] Adicionado icone para NPC ID: %d" % npc_id)


func set_run_config(rc: RunConfigSnapshot):
	run_config = rc


func get_npc_sprites(id: int):
	if npcs_sprites.has(id):
		return npcs_sprites.get(id)
	else:
		print_debug("[RunUi] ERRO: Sprite nao encontrada para NPC ID: %d" % id)
		return null
