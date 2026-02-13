extends Node
class_name WaveManager

## ============================================================================
## SISTEMA: WaveManager (Gerenciador de Ondas)
## ============================================================================
## 
## DESCRICAO:
## Responsavel por "spawnar" (criar) inimigos em volta da torre.
## Aumenta a dificuldade a cada onda.
##
## PADRAO: Spawner Pattern
## ============================================================================

signal wave_started(wave_number: int)
signal wave_completed(wave_number: int)

@export var spawn_radius: float = 600.0        # Distancia do centro onde inimigos nascem
@export var center_point: Vector2 = Vector2(576, 324) # Centro da tela (Alvo)
@export var enemy_scene: PackedScene = preload("res://entities/enemies/BaseEnemy.tscn")

# Lista de inimigos possiveis. Se vazia no Inspector, tenta pegar do SnapshotLoader.
@export var possible_enemies: Array[EnemySnapshot] = [] 

var current_wave: int = 0
var enemies_alive: int = 0


func _ready() -> void:
    # Espera um frame para garantir que o SnapshotLoader ja carregou os dados
    await get_tree().process_frame
    
    if possible_enemies.is_empty():
        possible_enemies = SnapshotLoader.get_all_enemies()
        if possible_enemies.is_empty():
            push_warning("[WaveManager] AVISO: Nenhum inimigo encontrado no SnapshotLoader!")
        else:
            print_debug("[WaveManager] Carregou %d tipos de inimigos do Loader." % possible_enemies.size())


## Inicia a proxima onda.
func start_next_wave() -> void:
    current_wave += 1
    print_debug("[WaveManager] === INICIANDO ONDA %d ===" % current_wave)
    wave_started.emit(current_wave)
    
    # Logica simples de dificuldade: Mais inimigos a cada onda (ex: 5, 7, 9...)
    var count = current_wave * 2 + 3
    spawn_wave(count)


## Spawna [count] inimigos com um pequeno intervalo entre eles.
func spawn_wave(count: int) -> void:
    print_debug("[WaveManager] Spawnando %d inimigos..." % count)
    for i in range(count):
        spawn_enemy()
        await get_tree().create_timer(0.3).timeout # Intervalo de 0.3s entre spawns


## Cria um unico inimigo em posicao aleatoria.
func spawn_enemy() -> void:
    if not enemy_scene:
        print_debug("[WaveManager] ERRO: Cena do inimigo (enemy_scene) nao definida!")
        return

    # Matematica: Escolhe um angulo aleatorio (0 a 360 graus em radianos)
    var angle = randf() * TAU
    # Calcula posicao X,Y baseada no angulo e raio (Coordenadas Polares -> Cartesianas)
    var spawn_pos = center_point + Vector2(cos(angle), sin(angle)) * spawn_radius
    
    var enemy = enemy_scene.instantiate()
    enemy.global_position = spawn_pos
    
    # Escolhe atributos aleatorios da lista
    if possible_enemies.size() > 0:
        var stats = possible_enemies.pick_random()
        # Tenta injetar os stats no inimigo
        if "stats" in enemy:
            enemy.stats = stats
    
    # Conecta o sinal de morte para sabermos quando a onda acaba
    if enemy.has_node("HealthComponent"):
        enemy.get_node("HealthComponent").died.connect(_on_enemy_died)
    
    get_tree().current_scene.add_child(enemy)
    enemies_alive += 1

    var def_id = stats.id if stats else "unknown"
    EventBus.entity_spawned.emit(enemy.get_instance_id(), def_id)

    # print_debug("[WaveManager] Inimigo criado em %s. Vivos: %d" % [spawn_pos, enemies_alive])


## Callback chamado quando um inimigo morre via HealthComponent.
func _on_enemy_died() -> void:
    enemies_alive -= 1
    print_debug("[WaveManager] Inimigo abatido. Restam: %d" % enemies_alive)
    
    if enemies_alive <= 0:
        print_debug("[WaveManager] ONDA %d COMPLETADA!" % current_wave)
        wave_completed.emit(current_wave)
        # EventBus.wave_completed.emit(current_wave) # Se quiser usar o evento global
