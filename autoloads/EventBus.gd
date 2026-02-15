extends Node

## ============================================================================
## ARQUITETURA: EventBus (Barramento de Eventos)
## ============================================================================
## 
## DESCRICAO:
## Este script atua como um "hub" central para comunicacao entre diferentes partes do jogo.
## Ele permite que scripts conversem entre si sem precisarem conhecer uns aos outros diretamente
## (Desacoplamento).
##
## PADRAO DE PROJETO: Observer (Observador)
## - Um script "emite" um sinal (grita que algo aconteceu).
## - Outros scripts "conectam" a esse sinal (escutam o grito e reagem).
##
## COMO USAR:
## 1. Para emitir: EventBus.nome_do_sinal.emit(arg1, arg2)
## 2. Para ouvir:  EventBus.nome_do_sinal.connect(funcao_de_callback)
##
## DICA DE DEBUG:
## Se um evento nao estiver funcionando, verifique:
## 1. Se o sinal esta sendo emitido (coloque um print onde o emit ocorre).
## 2. Se a conexao foi feita corretamente no _ready() do ouvinte.
## ============================================================================

## ============================================================================
## GAME LOOP EVENTS (Eventos de Loop de Jogo)
## ============================================================================
## Emitido quando uma onda comeca.
signal wave_started(wave_number: int)

## Emitido quando todos os inimigos de uma onda morrem.
signal wave_completed(wave_number: int)

## ============================================================================
## COMBAT EVENTS (Eventos de Combate)
## ============================================================================
## Emitido quando uma entidade leva dano.
## @param entity_id: ID unico da entidade ferida.
## @param amount: Quantidade de dano recebido.
## @param source: O nodo que causou o dano (pode ser null).
#########signal entity_damaged(entity_id: int, amount: int, source: Node)

## Emitido quando uma entidade morre (HP chega a 0).
## @param entity_id: ID unico da entidade que morreu.
signal entity_died(entity_id: int)

## Emitido quando uma entidade recupera vida.
## @param entity_id: ID unico da entidade curada.
## @param amount: Quantidade de vida recuperada.
######################signal entity_healed(entity_id: int, amount: int)

## ============================================================================
## SKILL EVENTS (Eventos de Habilidades)
## ============================================================================
## Emitido quando uma habilidade e usada.
##################signal skill_used(caster_id: int, skill_id: String, target: Vector2)

## Emitido quando um efeito de status e aplicado (ex: veneno, slow).
###############signal effect_applied(target_id: int, effect_id: String)

## Emitido quando uma habilidade entra em recarga (cooldown).
#############signal cooldown_started(entity_id: int, skill_id: String, duration: float)

## ============================================================================
## LOOT EVENTS (Eventos de Saque/Itens)
## ============================================================================
## Emitido quando um inimigo dropa um item no chao.
###########################signal loot_dropped(position: Vector2, loot_table_id: String)

## Emitido quando uma entidade pega um item do chao.
##########################signal item_picked_up(entity_id: int, item_id: String)

## ============================================================================
## STATE EVENTS (Eventos de Estado)
## ============================================================================
## Emitido quando o Estado de uma entidade muda (ex: de 'Idle' para 'Run').
#######################signal state_changed(entity_id: int, old_state: String, new_state: String)


## ============================================================================
## ENTITY LIFECYCLE (Ciclo de Vida de Entidades)
## ============================================================================

## Emitido quando uma entidade e criada (spawnada) no mundo.
## Util para sitemas que precisam rastrear todas as entidades vivas.
signal entity_spawned(eid: int, def_id: String)

## Emitido quando uma entidade e removida do jogo (despawnada).
signal entity_despawned(eid: int, reason: String)


## Funcao chamada automaticamente pelo Godot quando o jogo comeca.
func _ready() -> void:
	print_debug("[EventBus] --------------------------------------------------")
	print_debug("[EventBus] Sistema de Eventos Global (Singleton) INICIALIZADO")
	print_debug("[EventBus] --------------------------------------------------")
