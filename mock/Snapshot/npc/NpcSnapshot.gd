class_name NpcSnapshot
extends Resource


var npcs := [
	{"id": 0, "name": "Yasmin", "on_guild": true},
	{"id": 1, "name": "Patrick", "on_guild": true},
	{"id": 2, "name": "Fátima", "on_guild": true},
	{"id": 3, "name": "Bernardo", "on_guild": true},
	{"id": 4, "name": "Lorenza", "on_guild": true}
]

func get_npc_snapshot():
	return npcs

func get_npc_snapshot_with_id(id: int):
	return npcs.get(id)
