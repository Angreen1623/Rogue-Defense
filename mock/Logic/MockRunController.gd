class_name RunController
extends Resource

static var run_scene: PackedScene = Routes.get_route("run_scene")

var run_config: RunConfigSnapshot

func _on_start_run_button_pressed(_selected_npcs):
	pass


func set_run_config(rc: RunConfigSnapshot):
	run_config = rc

func get_run_build_snapshot():
	return run_config.get_RunConfig_snapshot()
