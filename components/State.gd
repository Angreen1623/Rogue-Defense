extends Node
class_name State

## ============================================================================
## CLASSE BASE: State (Estado)
## ============================================================================
## 
## DESCRICAO:
## Molde para criar estados especificos (ex: EstadoDeAtaque, EstadoDeMovimento).
## Funciona em conjunto com o StateMachine.
##
## COMO USAR:
## 1. Crie um novo script que extenda 'State'.
## 2. Sobrescreva as funcoes enter(), exit(), physics_update(), etc.
## ============================================================================

## Referencia a entidade que este estado controla (Player, Inimigo, etc).
## Injetado pelo StateMachine.
var entity: Node


## Chamado pelo StateMachine para configurar as dependencias.
func setup(p_entity: Node) -> void:
	entity = p_entity


## Chamado quando a maquina de estados ENTRA neste estado.
## Use para tocar animacoes, resetar timers, etc.
func enter() -> void:
	# print_debug("[%s] Entrou no estado: %s" % [entity.name if entity else "??", name])
	pass


## Chamado quando a maquina de estados SAI deste estado.
## Use para limpar variaveis, parar animacoes, etc.
func exit() -> void:
	pass


## Chamado para tratar input (teclado/mouse).
## So e executado se este for o estado atual.
func handle_input(_event: InputEvent) -> void:
	pass


## Chamado a cada frame de fisica (tipo _physics_process).
## So e executado se este for o estado atual.
func physics_update(_delta: float) -> void:
	pass
