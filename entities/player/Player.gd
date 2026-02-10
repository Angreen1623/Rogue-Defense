extends Actor
class_name Player

## ============================================================================
## ENTIDADE: Player (A Torre)
## ============================================================================
## 
## DESCRICAO:
## Representa a base do jogador.
## E uma entidade estatica (nao anda), mas tem vida e pode ser atacada.
##
## NOTA:
## Como herda de Actor (CharacterBody2D), tem fisica, mas ignoramos movimento.
## ============================================================================

func _ready() -> void:
	super._ready()
	
	print_debug("[Player] Torre inicializada e adicionada ao grupo 'player_tower'.")
	add_to_group("player_tower")

func _physics_process(_delta: float) -> void:
	# Torre nao se move, entao nao fazemos nada aqui.
	pass
