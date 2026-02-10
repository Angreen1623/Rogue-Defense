extends Actor
class_name BaseEnemy

## ============================================================================
## ENTIDADE: BaseEnemy (Inimigo Basico)
## ============================================================================
## 
## DESCRICAO:
## Logica especifica do inimigo.
## Ele busca o Player e anda na direcao dele usando o MovementComponent.
## ============================================================================

@export var target: Node2D
@export var stats: EnemySnapshot # Dados (vida, velocidade) injetados

func _ready() -> void:
	super._ready() # Chama o _ready do Actor
	
	print_debug("[Enemy] Inimigo nascendo...")
	
	# Aplica os dados do Snapshot (se houver)
	if stats:
		print_debug("[Enemy] Configurando stats: HP=%d, Spd=%.1f" % [stats.max_hp, stats.speed])
		if movement_component:
			movement_component.speed = stats.speed
		if health_component:
			health_component.set_max_hp(stats.max_hp, true)
	
	# Tenta encontrar o Player se nao tiver alvo definido manualmente
	if not target:
		var players = get_tree().get_nodes_in_group("player_tower")
		if players.size() > 0:
			target = players[0]
			print_debug("[Enemy] Alvo encontrado: %s" % target.name)
		else:
			print_debug("[Enemy] AVISO: Nenhum player encontrado na cena!")
	
	add_to_group("enemies") # Importante para a Torre achar esse inimigo


func _physics_process(delta: float) -> void:
	if target:
		var direction = global_position.direction_to(target.global_position)
		
		# Verifica se os componentes existem antes de usar
		if movement_component:
			var velocity_vector = movement_component.move_toward_direction(direction, delta)
			velocity = movement_component.velocity # Sincroniza velocity para o move_and_slide do CharacterBody2D
			move_and_slide()
		
		look_at(target.global_position)
