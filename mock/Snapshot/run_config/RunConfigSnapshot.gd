class_name RunConfigSnapshot
extends Node

static var selected_npcs : Array

func get_RunConfig_snapshot():
	return selected_npcs

func set_RunConfig(sn):
	selected_npcs = sn
