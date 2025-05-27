extends Card

#Create a test to see if the basic block works
#test
# func test_basic_attack_does_it_work()
	# var target = Enemy.new()
	# target.stats = Stats.new()
	# target.stats.hlock= 5
	# var choose_card = card.new()
	# choose_card.apply_effects([target])
	# assert_eq(target.stats.block, 8, "Block should increase by 3 after the function is run")
	
func apply_effects(targets: Array[Node]) -> void:
	var block_effect := BlockEffect.new()
	var total_block = 3 + GameManager.get_defense_bonus()
	block_effect.amount = total_block
	block_effect.execute(targets)