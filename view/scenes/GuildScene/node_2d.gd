extends Node2D

var camera_speed = 6

@onready var camera: Camera2D = $Camera2D
@onready var image: Sprite2D = $GeminiGeneratedImage1Ongg71Ongg71Ong


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if camera.position.x <= (2048 * 1.408) - get_viewport_rect().size.x:
		if Input.is_action_pressed("ui_right"):
			camera.position.x += camera_speed
	
	if camera.position.x >= 0:
		if Input.is_action_pressed("ui_left"):
			camera.position.x -= camera_speed
