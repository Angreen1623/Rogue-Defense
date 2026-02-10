class_name EnemySnapshot
extends Resource

## ============================================================================
## DADOS: EnemySnapshot (Retrato do Inimigo)
## ============================================================================
## 
## DESCRICAO:
## Um "Resource" e como um arquivo de dados (tipo um .json ou ScriptableObject no Unity).
## Ele guarda informacoes, mas nao tem comportamento (funcoes _process, etc).
## Usamos isso para criar "tipos" de inimigos sem precisar criar 50 scripts diferentes.
##
## COMO USAR:
## No Editor, clique com botao direito -> New Resource -> EnemySnapshot.
## Preencha os valores no Inspector.
## ============================================================================

@export var id: String = "enemy_basic"
@export var max_hp: int = 100
@export var speed: float = 50.0
@export var damage: int = 10
@export var sprite_frame: int = 0
