class_name Routes
extends Node

## ============================================================================
## UTILITARIO: ViewRotes (Rotas de Cena)
## ============================================================================
## 
## DESCRICAO:
## Um dicionario centralizado que mapeia "nomes" (strings) para "cenas" (PackedScene/UIDs).
## Ajuda a carregar cenas sem espalhar caminhos de arquivo (res://...) por todo o codigo.
## ============================================================================

const routes := {
	"run_scene": preload("uid://fw47674nx0ow"),   # Cena da Partida
	"guild_scene": preload("uid://b5kw620khnrhh"), # Cena da Guilda (Menu Principal)
	"enemy_scene": preload("uid://b8j20a04x8k1w")
}

## Retorna a cena correspondente ao ID.
static func get_route(id : String):
	if routes.has(id):
		return routes.get(id)
	else:
		print_debug("[ViewRotes] ERRO: Rota nao encontrada para ID: %s" % id)
		return null
