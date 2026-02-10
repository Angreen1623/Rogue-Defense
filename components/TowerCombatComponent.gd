extends Node
class_name TowerCombatComponent

## ============================================================================
## COMPONENTE: TowerCombatComponent (Combate da Torre)
## ============================================================================
## 
## DESCRICAO:
## Controla a aquisicao de alvos e o disparo de projeteis.
## Tipicamente usado pelo Player (Torre).
## ============================================================================

@export var projectile_scene: PackedScene
@export var fire_rate: float = 1.0     # Tiros por segundo
@export var range_area: Area2D         # Area de deteccao de inimigos
@export var projectile_spawn_point: Node2D # De onde o tiro sai

var current_target: Node2D
var cooldown_timer: float = 0.0


func _process(delta: float) -> void:
	# Gerencia o tempo de recarga
	if cooldown_timer > 0:
		cooldown_timer -= delta
		
	# Se nao tem alvo ou o alvo saiu da area/morreu, procura outro
	if not is_instance_valid(current_target) or not _is_target_in_range():
		current_target = _find_nearest_target()
		if current_target:
			print_debug("[Tower] Novo alvo adquirido: %s" % current_target.name)
		
	# Logica de disparo
	if current_target and cooldown_timer <= 0:
		fire()


## Procura o inimigo mais proximo dentro da area de alcance.
func _find_nearest_target() -> Node2D:
	if not range_area: 
		# print_debug("[Tower] ERRO: Range Area nao atribuida!")
		return null
	
	var bodies = range_area.get_overlapping_bodies()
	var nearest: Node2D = null
	var min_dist = INF
	
	for body in bodies:
		if body.is_in_group("enemies"):
			var dist = body.global_position.distance_squared_to(range_area.global_position)
			if dist < min_dist:
				min_dist = dist
				nearest = body
	
	return nearest


func _is_target_in_range() -> bool:
	if not range_area: return false
	return range_area.overlaps_body(current_target)


## Instancia e dispara um projetil.
func fire() -> void:
	if not projectile_scene:
		print_debug("[Tower] ERRO: Cena do projetil nao definida!")
		return
		
	if not current_target: 
		return
	
	# Reseta o cooldown (ex: 1.0 / 2.0 = 0.5s de espera)
	cooldown_timer = 1.0 / fire_rate
	
	var proj = projectile_scene.instantiate()
	# Confirma se e um projetil valido antes de configurar
	if proj is BaseProjectile:
		var spawn_pos = projectile_spawn_point.global_position if projectile_spawn_point else range_area.global_position
		
		proj.global_position = spawn_pos
		proj.direction = spawn_pos.direction_to(current_target.global_position)
		
		get_tree().current_scene.add_child(proj)
		print_debug("[Tower] Disparou projetil em direção a %s" % current_target.name)
	else:
		print_debug("[Tower] ERRO: A cena instanciada nao eh do tipo BaseProjectile!")
		proj.queue_free()
