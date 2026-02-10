extends GutTest

var movement_component: MovementComponent

func before_each():
	movement_component = MovementComponent.new()
	add_child_autofree(movement_component)

func test_initial_values():
	assert_eq(movement_component.velocity, Vector2.ZERO, "Velocity should start at ZERO")
	assert_gt(movement_component.speed, 0.0, "Speed should be greater than 0")

func test_move_toward_direction():
	var direction = Vector2.RIGHT
	var delta = 0.1
	
	# Simulate one frame of movement
	var displacement = movement_component.move_toward_direction(direction, delta)
	
	# Velocity should have increased towards RIGHT (acceleration)
	assert_gt(movement_component.velocity.x, 0.0, "Velocity X should increase")
	assert_eq(movement_component.velocity.y, 0.0, "Velocity Y should remain 0")
	
	# Displacement should be velocity * delta
	assert_eq(displacement, movement_component.velocity * delta, "Displacement mismatch")

func test_stop():
	movement_component.velocity = Vector2(100, 100)
	movement_component.stop()
	assert_eq(movement_component.velocity, Vector2.ZERO, "Velocity should be ZERO after stop")
