class_name EnemyViewPool
extends Resource

var scene: PackedScene = Routes.get_route("enemy_view")
var object_pool: Array = []

func add_to_pool(object: Node2D):
	object_pool.push_back(object)
	object.set_process(false)
	object.set_physics_process(false)
	object.hide()

func pull_from_pool():
	var object: Node2D
	if object_pool.is_empty():
		object = scene.instantiate()
	else:
		object = object_pool.pop_back()
	object.set_process(true)
	object.set_physics_process(true)
	object.show()
	return object
