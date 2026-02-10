class_name RunConfigSnapshot
extends Node

## ============================================================================
## DADOS: RunConfigSnapshot (Configuracao da Partida)
## ============================================================================
## 
## DESCRICAO:
## Guarda informacoes que precisam persistir entre cenas, mas nao salvam no disco.
## Exemplo: Quais NPCs voce escolheu levar para a batalha.
##
## ATENCAO:
## Usa 'static var', o que significa que a variavel e COMPARTILHADA por todas as
## instancias dessa classe. Funciona como um Global/Singleton simples.
## ============================================================================

static var selected_npcs : Array

## Retorna os NPCs escolhidos.
func get_RunConfig_snapshot():
	# print_debug("[RunConfig] Recuperando NPCs selecionados: %s" % str(selected_npcs))
	return selected_npcs


## Define os NPCs escolhidos.
func set_RunConfig(sn):
	print_debug("[RunConfig] Definindo NPCs selecionados: %s" % str(sn))
	selected_npcs = sn
