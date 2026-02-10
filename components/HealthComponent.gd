extends Node
class_name HealthComponent

## ============================================================================
## COMPONENTE: HealthComponent (Vida/Saue)
## ============================================================================
## 
## DESCRICAO:
## Gerencia a vida (HP) de qualquer entidade (Inimigo, Player, Torre).
## Se o HP chegar a 0, ele emite o sinal 'died'.
##
## COMO USAR:
## 1. Adicione este node como filho da entidade.
## 2. No script da entidade (ou Hurtbox), chame `take_damage(amount)`.
## ============================================================================

signal health_changed(current: int, maximum: int) # Emitido sempre que o HP muda
signal died # Emitido quando HP chega a 0

@export var max_hp: int = 100

var current_hp: int = 0


func _ready() -> void:
	current_hp = max_hp
	print_debug("[%s] HealthComponent pronto. HP Inicial: %d/%d" % [get_parent().name, current_hp, max_hp])


## Funcao para causar dano na entidade.
## @param amount: Quantidade de dano a ser subtraida.
func take_damage(amount: int) -> void:
	if amount <= 0:
		return

	var old_hp = current_hp
	current_hp = max(0, current_hp - amount)
	
	print_debug("[%s] Levou %d de dano. HP: %d -> %d" % [get_parent().name, amount, old_hp, current_hp])
	
	health_changed.emit(current_hp, max_hp)

	if current_hp <= 0:
		print_debug("[%s] MORREU!" % [get_parent().name])
		died.emit()
		EventBus.entity_died.emit(get_parent().get_instance_id())


## Funcao para curar a entidade.
## @param amount: Quantidade de vida a ser recuperada.
func heal(amount: int) -> void:
	if amount <= 0:
		return

	var old_hp := current_hp
	current_hp = min(max_hp, current_hp + amount)

	if current_hp != old_hp:
		print_debug("[%s] Curou %d de HP. HP: %d -> %d" % [get_parent().name, amount, old_hp, current_hp])
		health_changed.emit(current_hp, max_hp)
		EventBus.entity_healed.emit(get_parent().get_instance_id(), amount)


## Retorna verdadeiro se a entidade ainda tem vida.
func is_alive() -> bool:
	return current_hp > 0


## Retorna a porcentagem de vida (0.0 a 1.0).
## Util para barras de vida.
func get_hp_percent() -> float:
	return float(current_hp) / float(max_hp) if max_hp > 0 else 0.0


## Define um novo valor maximo de vida.
## @param value: Novo valor maximo.
## @param heal_to_max: Se deve curar totalmente a entidade ao mudar o maximo.
func set_max_hp(value: int, heal_to_max: bool = false) -> void:
	max_hp = max(1, value)
	if heal_to_max:
		current_hp = max_hp
		print_debug("[%s] Max HP alterado para %d e vida restaurada." % [get_parent().name, max_hp])
		health_changed.emit(current_hp, max_hp)
