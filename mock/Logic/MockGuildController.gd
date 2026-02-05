class_name GuildController
extends Resource

var npcs = NpcSnapshot.new()

var run_config: RunConfigSnapshot = RunConfigSnapshot.new()

func get_npcs_on_guild() -> Array:
	var on_guild_npcs : Array
	for i in npcs.get_npc_snapshot():
		if i.on_guild == true:
			on_guild_npcs.append(i)
	return on_guild_npcs

func build_run_config(selected_npcs):
	var npc_info = []
	
	for i in selected_npcs:
		var npcs_snapshot = npcs.get_npc_snapshot()
		npc_info.append(npcs_snapshot.get(i))
	
	run_config.set_RunConfig(npc_info)
