extends CharacterBody2D

@export var logic: EnemyLogic

func _ready() -> void:
	if logic == null:
		logic = EnemyLogic.new()

func _physics_process(delta: float) -> void:
	logic.tick(delta)
	
	var s: EnemySnapshot = logic.get_enemy_snapshot()
	velocity = s.velocity
	move_and_slide()
