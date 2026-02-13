extends Node

## ============================================================================
## SISTEMA: GameManager (Gerenciador do Jogo)
## ============================================================================
## 
## DESCRICAO:
## Controla o estado global da partida (Jogando, Venceu, Perdeu).
## Ouve eventos criticos (Morte da Torre, Fim de todas as Waves) para decidir o destino.
##
## COMO USAR:
## Geralmente e um Autoload (Singleton).
## ============================================================================

signal game_over
signal game_won

var is_game_active: bool = false
const MAX_WAVES: int = 5 # Definicao estatica de quantas ondas existem

func _ready() -> void:
	# Conecta nos sinais globais do EventBus
	EventBus.entity_died.connect(_on_entity_died)
	# Supondo que alguem emita wave_completed (provavelmente o WaveManager)
	# EventBus.wave_completed.connect(_on_wave_completed) # Comentado pois nao vi no EventBus original, verificar!
	
	print_debug("[GameManager] Jogo pronto. Aguardando inicio...")
	is_game_active = true


## Chamado quando QUALQUER entidade morre. Filtramos para saber se foi o Player.
func _on_entity_died(entity_id: int) -> void:
	var entity = instance_from_id(entity_id)
	if is_instance_valid(entity) and entity.is_in_group("player_tower"):
		print_debug("[GameManager] A TORRE CAIU! Game Over.")
		trigger_game_over()


# Exemplo de callback para vitoria (se existir sinal no EventBus ou conexao direta)
func _on_wave_completed(wave: int) -> void:
	print_debug("[GameManager] Onda %d completada." % wave)
	if wave >= MAX_WAVES:
		trigger_victory()
	else:
		# TODO: Trigger Draft / Upgrade screen here
		pass


## Ativa a derrota.
func trigger_game_over() -> void:
	if not is_game_active: return
	is_game_active = false
	
	game_over.emit()
	paused_game(true)
	print_debug("[GameManager] STATUS: GAME OVER")


## Ativa a vitoria.
func trigger_victory() -> void:
	if not is_game_active: return
	is_game_active = false
	
	game_won.emit()
	paused_game(true)
	print_debug("[GameManager] STATUS: VITORIA!")


## Pausa ou despausa o jogo (TimeScale).
func paused_game(paused: bool) -> void:
	get_tree().paused = paused
	print_debug("[GameManager] Jogo Pausado: %s" % str(paused))


## Reinicia a cena atual.
func restart_game() -> void:
	print_debug("[GameManager] Reiniciando partida...")
	paused_game(false)
	get_tree().reload_current_scene()
	is_game_active = true
