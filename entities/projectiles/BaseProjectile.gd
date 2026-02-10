extends Node2D
class_name BaseProjectile

## ============================================================================
## ENTIDADE: BaseProjectile (Projetil Basico)
## ============================================================================
## 
## DESCRICAO:
## Objeto simples que anda em linha reta ate bater em algo ou o tempo acabar.
## ============================================================================

@export var speed: float = 600.0
@export var damage: int = 10
@export var lifetime: float = 3.0

var direction: Vector2 = Vector2.RIGHT

func _ready() -> void:
    # Configura um timer para se destruir sozinho (evita lixo de memoria)
    print_debug("[Projectile] Disparado! Tempo de vida: %.1fs" % lifetime)
    await get_tree().create_timer(lifetime).timeout
    
    if is_instance_valid(self):
        print_debug("[Projectile] Tempo expirou. Destruindo.")
        queue_free()

func _physics_process(delta: float) -> void:
    # Movimento linear simples (S = So + V * t)
    position += direction * speed * delta

# Chamado (provavelmente por sinal) quando acerta algo
func _on_hitbox_hit_landed(_hurtbox: Area2D) -> void:
    # print_debug("[Projectile] Acertou alvo! Destruindo.")
    queue_free()
