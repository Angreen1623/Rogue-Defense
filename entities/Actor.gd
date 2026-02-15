extends CharacterBody2D
class_name Actor

## ============================================================================
## CLASSE BASE: Actor (Ator)
## ============================================================================
## 
## DESCRICAO:
## Base para todos os personagens que se movem ou tem corpo fisico (Inimigos, Player).
## Usa o sistema de COMPOSICAO: O Actor e "burro", os Componentes filhos que dao as habilidades.
##
## NOTA DE ARQUITETURA:
## Mudamos de 'Node' para 'CharacterBody2D' para permitir uso de move_and_slide()
## nos script filhos (como BaseEnemy).
## ============================================================================

# Buscamos os componentes automaticamente ao iniciar
@onready var health_component: HealthComponent = $HealthComponent
@onready var movement_component: MovementComponent = $MovementComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
# @onready var state_machine: StateMachine = $StateMachine # Comentado se nao tiver node, descomentar se usar

func _ready() -> void:
	# Inicializacao comum a todos os Atores
	pass

func _physics_process(delta: float) -> void:
	# StateMachine geralmente gerencia isso, mas se precisar de logica global, vem aqui.
	pass


func _exit_tree() -> void:
	EventBus.entity_despawned.emit(get_instance_id(), "removed")
