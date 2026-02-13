extends Area2D
class_name HitboxComponent

## ============================================================================
## COMPONENTE: HitboxComponent (Caixa de Colisao/Ataque)
## ============================================================================
## 
## DESCRICAO:
## Representa a area de dano de um ataque (ex: lamina da espada, projetil).
## Quando encosta em um 'HurtboxComponent', causa dano.
##
## ATENCAO:
## Precisa ter um CollisionShape2D como filho para ter forma fisica.
## ============================================================================

signal hit_landed(target: Node, damage: int)

@export var damage: int = 10
@export var damage_type: String = "physical"
@export var knockback_force: float = 100.0

var _is_active: bool = false
var _hit_targets: Array[Node] = []


func _ready() -> void:
	# Conecta o sinal do proprio Godot para detectar entrada de areas
	area_entered.connect(_on_area_entered)
	deactivate() # Comeca desativado por seguranca


## Ativa a hitbox para comecar a causar dano.
## Usado geralmente em animacoes de ataque.
func activate() -> void:
	_is_active = true
	_hit_targets.clear() # Limpa a lista de quem ja apanhou
	monitoring = true
	monitorable = true
	print_debug("[%s] Hitbox ATIVADA (Dano: %d)" % [get_parent().name, damage])


## Desativa a hitbox.
func deactivate() -> void:
	_is_active = false
	monitoring = false
	monitorable = false
	# print_debug("[%s] Hitbox DESATIVADA" % [get_parent().name]) # Comentado para nao spammar


## Callback interno: Chamado quando outra area encosta nesta.
func _on_area_entered(area: Area2D) -> void:
	if not _is_active:
		return

	# Verifica se acertamos um Hurtbox (algo que pode levar dano)
	if area is HurtboxComponent:
		var hurtbox := area as HurtboxComponent
		var target := hurtbox.get_parent()

		# Evita acertar o mesmo alvo varias vezes no mesmo ataque (frame perfect)
		if target in _hit_targets:
			return
		_hit_targets.append(target)

		print_debug("[%s] Hitbox acertou: %s (Dano: %d)" % [get_parent().name, target.name, damage])

		# Aplica o dano no Hurtbox
		hurtbox.receive_hit(damage, damage_type, get_parent())
		hit_landed.emit(target, damage)

		# Aplica empurrao (Knockback) se o alvo se move (CharacterBody2D)
		if knockback_force > 0 and target is CharacterBody2D:
			var direction = (target.global_position - global_position).normalized()
			target.velocity += direction * knockback_force
			print_debug("[%s] Aplicou knockback em %s" % [get_parent().name, target.name])
