class_name NpcSnapshot
extends Resource

## ============================================================================
## DADOS: NpcSnapshot
## ============================================================================
## 
## DESCRICAO:
## Contem a lista de NPCs disponiveis no jogo.
## Atualmente hardcoded (escrito direto no codigo), mas poderia vir de um arquivo.
## ============================================================================

# Simula um banco de dados de NPCs
var npcs := [
	{"id": 0, "name": "Yasmin", "on_guild": true},
	{"id": 1, "name": "Patrick", "on_guild": true},
	{"id": 2, "name": "Fátima", "on_guild": true},
	{"id": 3, "name": "Bernardo", "on_guild": true},
	{"id": 4, "name": "Lorenza", "on_guild": true}
]

## Retorna todos os NPCs.
func get_npc_snapshot():
	# print_debug("[NpcSnapshot] Retornando lista de %d NPCs." % npcs.size())
	return npcs

## Busca um NPC especifico pelo ID (indice no array).
func get_npc_snapshot_with_id(id: int):
	# print_debug("[NpcSnapshot] Buscando NPC ID: %d" % id)
	if id >= 0 and id < npcs.size():
		return npcs[id]
	else:
		print_debug("[NpcSnapshot] ERRO: ID %d invalido!" % id)
		return null
