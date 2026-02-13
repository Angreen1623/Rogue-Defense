class_name GuildController
extends Resource

## ============================================================================
## CONTROLADOR: GuildController (Logica da Guilda)
## ============================================================================
## 
## DESCRICAO:
## Gere a lista de NPCs disponiveis e prepara a configuracao da partida (RunConfig).
## Atua como uma ponte entre a UI e os dados persistentes (Snapshots).
## ============================================================================

var npcs = NpcSnapshot.new()
var run_config = RunConfigSnapshot.new()

## Retorna a lista de NPCs que estao "na guilda" (disponiveis para missao).
func get_npcs_on_guild() -> Array:
	var on_guild_npcs : Array = []
	# Usamos o SnapshotLoader para garantir dados atualizados se necessario, 
	# mas o Mock original usava a instancia local de NpcSnapshot.
	for npc in npcs.get_npc_snapshot():
		if npc.get("on_guild", false):
			on_guild_npcs.append(npc)
	return on_guild_npcs


## Recebe uma lista de IDs de NPCs e monta a configuracao da Run no Snapshot Estatico.
func build_run_config(selected_npcs_ids: Array) -> void:
	var npc_info = []
	
	for id in selected_npcs_ids:
		# Busca o dicionario completo do NPC pelo ID
		var npc = npcs.get_npc_snapshot_with_id(id)
		if npc:
			npc_info.append(npc)
	
	print_debug("[GuildController] Montando RunConfig com %d NPCs." % npc_info.size())
	run_config.set_RunConfig(npc_info)
