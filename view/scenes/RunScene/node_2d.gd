extends Node2D

var enemy_spawners = []
var enemies = []
var max_enemy = 6

var time = 0

@export var pool: EnemyViewPool


func _ready() -> void:
	if pool == null:
		pool = EnemyViewPool.new()

func _process(_delta: float) -> void:
	process_debbug(_delta)

func spawn_enemy():
	var new_enemy = pool.pull_from_pool()
	var temp_pos: Vector2 = Vector2(randf_range(0, get_viewport().get_visible_rect().size.x), randf_range(0, get_viewport().get_visible_rect().size.y))
	new_enemy.global_position = temp_pos
	if not new_enemy.is_inside_tree():
		get_tree().current_scene.add_child(new_enemy)
	
	enemies.append(new_enemy)
	if enemies.size() >= max_enemy:
		pool.add_to_pool(enemies.pop_front())



func process_debbug(delta):
	time += delta
	if time >= 1:
		spawn_enemy()
		time = 0
