extends GutTest

var health: HealthComponent
var actor: Actor
var last_damaged_id = -1
var last_amount = -1

func before_each():
    actor = Actor.new()
    actor.name = "TestActor"
    add_child_autofree(actor)
    
    health = HealthComponent.new()
    actor.add_child(health)
    health._ready()
    
    EventBus.entity_damaged.connect(_on_entity_damaged)

func _on_entity_damaged(id, amount, source):
    last_damaged_id = id
    last_amount = amount

func test_entity_damaged_signal():
    health.take_damage(20)
    assert_eq(last_damaged_id, actor.get_instance_id(), "Should emit correct entity ID")
    assert_eq(last_amount, 20, "Should emit correct damage amount")

func test_entity_despawned_signal():
    var signal_received = false
    var check_id = actor.get_instance_id()
    
    EventBus.entity_despawned.connect(func(id, reason): 
        if id == check_id: signal_received = true
    )
    
    actor.queue_free()
    await wait_for_signal(actor.tree_exited, 1.0)
    
    assert_true(signal_received, "Should emit entity_despawned when actor is removed from tree")
