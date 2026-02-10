extends Area2D
class_name HurtboxComponent

## ============================================================================
## COMPONENTE: HurtboxComponent (Caixa de Dano/Vulnerabilidade)
## ============================================================================
## 
## DESCRICAO:
## Area que detecta ataques (HitboxComponent).
## Funciona como a "pele" ou "armadura" da entidade.
## Quando atingido, repassa o dano para o HealthComponent (se existir).
## ============================================================================

signal damage_received(amount: int, damage_type: String, source: Node)

@export var invincibility_time: float = 0.0

var _invincible: bool = false


func _ready() -> void:
	collision_layer = 4  # Camada especifica para Hurtboxes (definido nas configs do projeto)
	collision_mask = 0  # Hurtbox nao detecta nada ativamente, so eh detectado
	print_debug("[%s] Hurtbox pronta." % [get_parent().name])


## Funcao chamada pelo Hitbox quando ocorre um acerto.
## @param amount: Dano recebido.
## @param damage_type: Tipo de dano (fisico, magico, fogo, etc).
## @param source: Quem atacou.
func receive_hit(amount: int, damage_type: String, source: Node) -> void:
	if _invincible:
		print_debug("[%s] Atingido, mas esta INVENCIVEL." % [get_parent().name])
		return

	print_debug("[%s] Hurtbox atingida por %s. Dano: %d (%s)" % [get_parent().name, source.name, amount, damage_type])

	damage_received.emit(amount, damage_type, source)

	# Tenta encontrar o HealthComponent irmao para aplicar o dano real
	var health := get_parent().get_node_or_null("HealthComponent") as HealthComponent
	if health:
		health.take_damage(amount)
	else:
		print_debug("[%s] AVISO: Hurtbox atingida mas sem HealthComponent!" % [get_parent().name])

	# Inicia invencibilidade temporaria (piscar)
	if invincibility_time > 0:
		_start_invincibility()


## Inicia o periodo de imortalidade pos-dano.
func _start_invincibility() -> void:
	_invincible = true
	# print_debug("[%s] Ficou invencivel por %.2f segundos." % [get_parent().name, invincibility_time])
	
	# Cria um timer descartavel
	await get_tree().create_timer(invincibility_time).timeout
	
	_invincible = false
	# print_debug("[%s] Invencibilidade acabou." % [get_parent().name])


func is_invincible() -> bool:
	return _invincible
