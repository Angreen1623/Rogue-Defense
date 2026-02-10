extends CharacterBody2D
class_name EnemyView

## ============================================================================
## VISUAL: EnemyView (Visual do Inimigo)
## ============================================================================
## 
## DESCRICAO:
## Controla a representacao visual e fisica do inimigo na tela.
## Recebe dados de logica (EnemyLogic) e aplica movimento.
##
## NOTA:
## Se houver conflito com BaseEnemy.gd, verifique qual script deve estar no no raiz.
## Este script assume que ELE controla o move_and_slide().
## ============================================================================

@export var logic: EnemyLogic # Logica separada (Padrao MVC)

func _ready() -> void:
    if logic == null:
        logic = EnemyLogic.new()
        print_debug("[EnemyView] Logic nao injetada, criando nova: %s" % logic)
    
    print_debug("[EnemyView] Inimigo visual pronto.")


func _physics_process(delta: float) -> void:
    if logic:
        # Atualiza a logica (IA, decisoes)
        logic.tick(delta)
        
        # Aplica o resultado fisico
        var s: EnemySnapshot = logic.get_enemy_snapshot()
        if s:
            # velocity = s.velocity # Assume que o snapshot tem velocity (Cuidado: Snapshot costuma ser dados estaticos)
            # Se Snapshot for dados dinamicos, OK. Se for Resource estatico, isso vai dar erro.
            # Assumindo que EnemyLogic mantem o estado atual em um objeto parecido com Snapshot ou struct interna.
            pass
            
        move_and_slide()
