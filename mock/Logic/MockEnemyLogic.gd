class_name EnemyLogic
extends Resource

var velocity := Vector2.ZERO
var speed := 50.0

func tick(_delta: float) -> void:
	velocity.x = speed

func get_enemy_snapshot() -> EnemySnapshot:
	return EnemySnapshot.new(velocity)
