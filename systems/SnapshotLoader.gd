extends Node

## ============================================================================
## SISTEMA: SnapshotLoader (Carregador de Dados)
## ============================================================================
## 
## DESCRICAO:
## Responsavel por varrer as pastas do projeto e carregar todos os "Snapshots"
## (EnemySnapshot, NpcSnapshot) para a memoria RAM no inicio do jogo.
## Funciona como um Registro Central (Database).
## ============================================================================

var enemy_snapshots: Array[EnemySnapshot] = []
var npc_data: NpcSnapshot


func _ready() -> void:
	print_debug("[SnapshotLoader] Iniciando carregamento de dados...")
	_load_enemies()
	_load_npcs()
	print_debug("[SnapshotLoader] Total de inimigos carregados: %d" % enemy_snapshots.size())


func _load_npcs() -> void:
	# Carrega o arquivo de NPCs (caminho fixo por enquanto)
	if ResourceLoader.exists("res://data/legacy_data/npc/NpcSnapshot.tres"):
		npc_data = load("res://data/legacy_data/npc/NpcSnapshot.tres")
		print_debug("[SnapshotLoader] NPC Snapshot carregado com sucesso.")
	else:
		push_warning("[SnapshotLoader] AVISO: NpcSnapshot.tres nao encontrado!")


func _load_enemies() -> void:
	# 1. Carrega inimigos legados
	_scan_directory("res://data/legacy_data/enemy/")
	
	# 2. Carrega novos inimigos (se houver)
	_scan_directory("res://resources/enemies/")


## Varre uma pasta e carrega todos os .tres ou .res encontrados.
func _scan_directory(path: String) -> void:
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if not dir.current_is_dir():
				# Filtra apenas arquivos de recurso
				if file_name.ends_with(".tres") or file_name.ends_with(".res"):
					var full_path = path + "/" + file_name
					full_path = full_path.replace("//", "/") # Corrige barras duplas
					
					var res = load(full_path)
					if res is EnemySnapshot:
						enemy_snapshots.append(res)
						print_debug("[SnapshotLoader] Inimigo carregado: %s" % file_name)
			
			file_name = dir.get_next()
	else:
		print_debug("[SnapshotLoader] ERRO: Diretorio nao encontrado: " + path)


## Retorna a lista completa de inimigos.
func get_all_enemies() -> Array[EnemySnapshot]:
	return enemy_snapshots


## Retorna um inimigo aleatorio (para o WaveManager usar).
func get_random_enemy() -> EnemySnapshot:
	if enemy_snapshots.is_empty():
		print_debug("[SnapshotLoader] ERRO: Tentou pegar inimigo randomico mas a lista esta vazia!")
		return null
	
	return enemy_snapshots.pick_random()


## Retorna os dados crus dos NPCs.
func get_all_npcs() -> Array:
	if npc_data:
		return npc_data.get_npc_snapshot()
	return []


## Retorna um NPC pelo ID.
func get_npc_by_id(id: int) -> Dictionary:
	if npc_data:
		return npc_data.get_npc_snapshot_with_id(id)
	return {}
