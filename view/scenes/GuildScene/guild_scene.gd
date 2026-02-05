extends Node

@onready var guild_ui: Control = $UI/GuildUi
@onready var selecting_npcs: Control = $UI/SelectingNpcs


func _on_guild_ui_start_run() -> void:
	guild_ui.hide()
	selecting_npcs.show()
