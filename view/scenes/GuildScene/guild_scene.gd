extends Node

## ============================================================================
## CENA: GuildScene (Cena da Guilda)
## ============================================================================
## 
## DESCRICAO:
## Controla o fluxo na tela da Guilda (Menu Principal).
## Alterna entre o menu principal e a selecao de personagens.
## ============================================================================

@onready var guild_ui: Control = $UI/GuildUi
@onready var selecting_npcs: Control = $UI/SelectingNpcs


func _on_guild_ui_start_run() -> void:
	print_debug("[GuildScene] Iniciando selecao de personagens...")
	guild_ui.hide()
	selecting_npcs.show()
