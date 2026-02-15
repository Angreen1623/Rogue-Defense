extends Node2D

@export var npc_scene: PackedScene = preload("res://entities/npc/BaseNpc.tscn")

@onready var wave_manager: WaveManager = get_node_or_null("../WaveManager")
@onready var player: Node2D = get_node_or_null("../Player")

# Mapeamento de ID de NPC -> Textura (Copiado de RunUi)
var npcs_sprites := {
	0: preload("uid://bohtq6f4si33e"),
	1: preload("uid://c6x6jf646gnjw"),
	2: preload("uid://ckvd0463qppl"),
	3: preload("uid://b17qdvevi3aao"),
	4: preload("uid://c0xtumgff7f8w")
}

func _ready() -> void:
	spawn_allies()
	
	if wave_manager:
		# Pequeno atraso para garantir que o SnapshotLoader e outros sistemas estao prontos
		await get_tree().create_timer(1.0).timeout
		print_debug("[RunScene] Iniciando primeira onda...")
		wave_manager.start_next_wave()
	else:
		push_warning("[RunScene] WaveManager nao encontrado na cena!")

func spawn_allies() -> void:
	var run_config = RunConfigSnapshot.new()
	var selected_npcs = run_config.get_RunConfig_snapshot()
	
	if selected_npcs == null or selected_npcs.is_empty():
		print_debug("[RunScene] Nenhum NPC para spawnar.")
		return
		
	print_debug("[RunScene] Spawnando %d aliados..." % selected_npcs.size())
	
	var center = Vector2(576, 324)
	if player:
		center = player.global_position
		
	var radius = 80.0
	var count = selected_npcs.size()
	
	for i in range(count):
		var npc_data = selected_npcs[i]
		var npc_id = npc_data.get("id", -1)
		
		# Distribui em circulo ao redor do player
		var angle = (TAU / count) * i
		var offset = Vector2(cos(angle), sin(angle)) * radius
		var spawn_pos = center + offset
		
		var npc_instance = npc_scene.instantiate()
		npc_instance.global_position = spawn_pos
		
		# Setup visual
		var texture = npcs_sprites.get(npc_id)
		if npc_instance.has_method("setup"):
			npc_instance.setup(npc_data, texture)
			
		add_child(npc_instance)

func _process(_delta: float) -> void:
	# Debug key para iniciar proxima onda manualmente
	if Input.is_action_just_pressed("ui_accept"):
		if wave_manager:
			wave_manager.start_next_wave()
