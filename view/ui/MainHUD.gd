extends Control
class_name MainHUD

## ============================================================================
## INTERFACE: MainHUD (Heads-Up Display Principal)
## ============================================================================
## 
## DESCRICAO:
## Controla a interface da partida (Barra de Vida, Texto de onda, Mensagens de Vitoria).
## Ouve sinais globais (EventBus, GameManager) para atualizar a tela.
## ============================================================================

@onready var health_bar: ProgressBar = %HealthBar
@onready var wave_label: Label = %WaveLabel
@onready var message_label: Label = %MessageLabel

var player: Player # Referencia ao Player (Torre) para ler a vida maxima inicial

func _ready() -> void:
    print_debug("[MainHUD] Iniciando interface...")

    # Conecta eventos globais
    EventBus.wave_started.connect(_on_wave_started)
    EventBus.wave_completed.connect(_on_wave_completed)
    
    # Conecta sinais do GameManager
    GameManager.game_over.connect(_on_game_over)
    GameManager.game_won.connect(_on_game_won)

    # Tenta encontrar o Player para conectar a barra de vida
    var players = get_tree().get_nodes_in_group("player_tower")
    if players.size() > 0:
        player = players[0]
        _connect_player_signals()
        print_debug("[MainHUD] Player encontrado no inicio.")
    else:
        # Se o player ainda nao nasceu, espera ele entrar na arvore
        print_debug("[MainHUD] Player nao encontrado. Aguardando...")
        get_tree().node_added.connect(_on_node_added)


## Callback temporario para detectar quando o Player entra na cena
func _on_node_added(node: Node) -> void:
    if node is Player:
        print_debug("[MainHUD] Player detectado! Conectando sinais.")
        player = node
        _connect_player_signals()
        get_tree().node_added.disconnect(_on_node_added)


func _connect_player_signals() -> void:
    if player.has_node("HealthComponent"):
        var health_comp = player.get_node("HealthComponent")
        # Conecta sinal de mudanca de vida
        health_comp.health_changed.connect(_on_health_changed)
        # Atualiza o valor inicial
        _update_health_bar(health_comp.current_hp, health_comp.max_hp)
    else:
        print_debug("[MainHUD] ERRO: Player nao tem HealthComponent!")


func _update_health_bar(current: int, max_hp: int) -> void:
    health_bar.max_value = max_hp
    health_bar.value = current
    # Opcional: print_debug para ver a vida mudando no log (pode spammar)


func _on_health_changed(current: int, max_hp: int) -> void:
    _update_health_bar(current, max_hp)


func _on_wave_started(wave: int) -> void:
    wave_label.text = "Wave: %d" % wave
    _show_message("Wave %d Started!" % wave)


func _on_wave_completed(wave: int) -> void:
    _show_message("Wave %d Cleared!" % wave)


func _on_game_over() -> void:
    _show_message("GAME OVER")
    # TODO: Mostrar botao de restart


func _on_game_won() -> void:
    _show_message("VICTORY!")


## Exibe uma mensagem na tela que desaparece apos um tempo (Fade Out).
func _show_message(text: String) -> void:
    print_debug("[MainHUD] Mensagem: %s" % text)
    message_label.text = text
    message_label.visible = true
    
    # Animacao simples usando Tween
    var tween = create_tween()
    tween.tween_property(message_label, "modulate:a", 1.0, 0.5) # Aparece
    
    if not GameManager.is_game_active: return # Se acabou o jogo, mantem a mensagem fixa
    
    tween.tween_interval(2.0) # Espera 2 segundos
    tween.tween_property(message_label, "modulate:a", 0.0, 0.5) # Desaparece (transparente)
