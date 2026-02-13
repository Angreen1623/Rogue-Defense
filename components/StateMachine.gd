extends Node
class_name StateMachine

## ============================================================================
## COMPONENTE: StateMachine (Maquina de Estados Finita)
## ============================================================================
## 
## DESCRICAO:
## Gerencia qual 'State' esta ativo no momento.
## Garante que apenas UM estado rode por vez (ex: ou esta Andando OU Atacando).
##
## PADRAO: State Pattern
## - "Call Down": StateMachine chama funcoes no Estado Atual.
## - "Signal Up": Estados emitem sinais ou chamam funcoes na StateMachine para trocar.
## ============================================================================

signal state_changed(old_state_name: String, new_state_name: String)

@export var initial_state: State

var current_state: State
var states: Dictionary = {}


func _ready() -> void:
	# Aguarda o proximo frame para garantir que os filhos (Estados) estao prontos
	await get_tree().process_frame
	initialize()


## Inicializa a maquina, registrando todos os estados filhos.
func initialize() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			# Injeta a dependencia da entidade (o avo do estado, ou seja, o pai da StateMachine)
			child.setup(get_parent())
	
	if initial_state:
		print_debug("[%s] StateMachine iniciada. Estado inicial: %s" % [get_parent().name, initial_state.name])
		change_state(initial_state.name)


## Verifica se um estado existe pelo nome.
func has_state(state_name: String) -> bool:
	return states.has(state_name.to_lower())


## Troca para um novo estado.
## @param new_state_name: Nome do nodo do proximo estado.
func change_state(new_state_name: String) -> void:
	var new_state := states.get(new_state_name.to_lower()) as State
	
	if new_state == null:
		print_debug("[%s] ERRO: Tentou trocar para estado inexistente: %s" % [get_parent().name, new_state_name])
		return
		
	if new_state == current_state:
		return
	
	var old_name = current_state.name if current_state else "None"
	
	print_debug("[%s] Transicao de Estado: %s -> %s" % [get_parent().name, old_name, new_state.name])
	
	# 1. Sai do estado atual
	if current_state:
		current_state.exit()
	
	# 2. Atualiza a referencia
	current_state = new_state
	
	# 3. Entra no novo estado
	current_state.enter()
	
	state_changed.emit(old_name, new_state.name)


## Redireciona inputs para o estado atual.
func _unhandled_input(event: InputEvent) -> void:
	if current_state:
		current_state.handle_input(event)


## Redireciona processamento de fisica para o estado atual.
func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)
