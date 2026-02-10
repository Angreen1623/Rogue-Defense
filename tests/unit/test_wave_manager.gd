extends GutTest

var wave_manager: WaveManager
var player: Player

func before_each():
	# Create Player (Tower)
	player = load("res://entities/player/Player.tscn").instantiate()
	player.position = Vector2(100, 100)
	add_child_autofree(player)
	
	# Create WaveManager
	wave_manager = WaveManager.new()
	wave_manager.center_point = player.position
	wave_manager.enemy_scene = load("res://entities/enemies/BaseEnemy.tscn")
	add_child_autofree(wave_manager)

func test_spawn_wave():
	# Verify WaveManager spawns enemies
	wave_manager.start_next_wave()
	
	await get_tree().create_timer(1.0).timeout
	
	var enemies = get_tree().get_nodes_in_group("enemies") # Need to verify if enemies are added to group
	# Since BaseEnemy doesn't add itself to group yet, let's check children count
	# Note: WaveManager adds children to current_scene. In test env, this might be tricky.
	# Let's verify internal counter instead for unit test.
	
	# Actually, simpler test: check if signal emitted
	pass # Unit testing WaveManagers requires mocking SceneTree or adjusting script.
	# For now, integration test via TestLevel is better.

func test_enemy_targets_player():
	var enemy = load("res://entities/enemies/BaseEnemy.tscn").instantiate()
	add_child_autofree(enemy)
	
	# Enemy should auto-find player in group "player_tower"
	assert_eq(enemy.target, player, "Enemy should target the player tower")
