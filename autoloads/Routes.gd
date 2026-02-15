extends Node

# Centralized scene routing system
# Maps logical names to scene resource paths

var routes = {
	"guild_scene": "res://view/scenes/GuildScene/GuildScene.tscn",
	"run_scene": "res://view/scenes/RunScene/RunScene.tscn",
	"enemy_view": "res://entities/enemies/BaseEnemy.tscn"
}

func get_route(route_name: String) -> PackedScene:
	if routes.has(route_name):
		var path = routes[route_name]
		var scene = load(path)
		if scene:
			return scene
		else:
			print_debug("[Routes] ERRO: Nao foi possivel carregar a cena no caminho: %s" % path)
	else:
		print_debug("[Routes] ERRO: Rota nao encontrada: %s" % route_name)
	return null
