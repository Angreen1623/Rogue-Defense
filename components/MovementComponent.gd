extends Node
class_name MovementComponent

## ============================================================================
## COMPONENTE: MovementComponent (Movimentacao)
## ============================================================================
## 
## DESCRICAO:
## Encapsula a logica de movimento baseada em fisica (velocidade, aceleracao, atrito).
## Nao move a entidade diretamente, mas calcula a 'velocity' que o script do pai deve usar.
##
## ============================================================================

signal moved(velocity: Vector2)

@export var speed: float = 100.0       # Velocidade maxima
@export var acceleration: float = 800.0 # Quao rapido chega na velocidade maxima
@export var friction: float = 600.0     # Quao rapido para quando solta os botoes

var velocity: Vector2 = Vector2.ZERO


## Calcula a nova velocidade baseada na direcao desejada.
## @param direction: Vetor normalizado de direcao (input).
## @param delta: Tempo desde o ultimo frame.
## @return: O deslocamento a ser aplicado (velocity * delta).
func move_toward_direction(direction: Vector2, delta: float) -> Vector2:
	# Se tem direcao, acelera
	if direction.length_squared() > 0:
		var target_velocity := direction.normalized() * speed
		velocity = velocity.move_toward(target_velocity, acceleration * delta)
	# Se nao tem direcao, freia (atrito)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	# Emite sinal apenas se estiver se movendo significativamente
	if velocity.length_squared() > 0.01:
		moved.emit(velocity)
		# Nota: Nao colocamos print aqui para nao spammar o console (acontece 60x por segundo)

	return velocity * delta


## Define uma direcao e velocidade instantaneamente (sem aceleracao).
func move_instant(direction: Vector2) -> Vector2:
	velocity = direction.normalized() * speed if direction.length_squared() > 0 else Vector2.ZERO

	if velocity.length_squared() > 0.01:
		print_debug("[%s] Move Instant: %s" % [get_parent().name, velocity])
		moved.emit(velocity)

	return velocity


## Para o movimento imediatamente.
func stop() -> void:
	if velocity.length_squared() > 0:
		print_debug("[%s] MovementComponent PAROU." % [get_parent().name])
	velocity = Vector2.ZERO


## Retorna para onde a entidade esta "olhando" com base no movimento.
## Se estiver parada, mantem a direita (Vector2.RIGHT) ou ultima direcao valida (se implementar memoria).
func get_facing_direction() -> Vector2:
	return velocity.normalized() if velocity.length_squared() > 0.01 else Vector2.RIGHT
