extends GutTest

var controller: GuildController

func before_each():
    controller = GuildController.new()

func test_get_npcs_on_guild():
    var npcs_list = controller.get_npcs_on_guild()
    assert_eq(npcs_list.size(), 5, "Should return 5 NPCs from the snapshot")
    for npc in npcs_list:
        assert_eq(npc.on_guild, true, "Each NPC should have on_guild set to true")

func test_build_run_config():
    var selected_ids = [0, 2] # Yasmin and Fátima
    controller.build_run_config(selected_ids)
    
    var run_config = RunConfigSnapshot.new()
    var snapshot = run_config.get_RunConfig_snapshot()
    
    assert_eq(snapshot.size(), 2, "RunConfig should have 2 NPCs")
    assert_eq(snapshot[0].name, "Yasmin", "First selected NPC should be Yasmin")
    assert_eq(snapshot[1].name, "Fátima", "Second selected NPC should be Fátima")
