extends Node2D

var camera_speed = 6

@onready var camera: Camera2D = $Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if camera.position.x <= 1096:
		if Input.is_action_pressed("ui_right"):
			camera.position.x += camera_speed
	
	if camera.position.x >= 0:
		if Input.is_action_pressed("ui_left"):
			camera.position.x -= camera_speed
