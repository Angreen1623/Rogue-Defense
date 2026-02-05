class_name Routes
extends Node

const routes := {
	"run_scene": preload("uid://fw47674nx0ow"),
	"guild_scene": preload("uid://b5kw620khnrhh"),
	"enemy_view": preload("uid://du6oitejkdygm")
}

static func get_route(id : String):
	return routes.get(id)
