class_name BlockEffect
extends Effect

var amount: int = 0
#Test
# Goal: make sure that it increases block for each valid target 
#func test_block_does_it_work()
	# var target = Enemy.new()
	# target.stats = Stats.new()
	# target.stats.block = 2;
	# var effect = BlockEffect.new()
	# effect.amount = 4
	# effect.execute([target])
	# assert_eq(target.stats.block, 6, "Block should increase by 4")

func execute(targets: Array[Node]) -> void:
	for target in targets:
		if not target:
			continue
		if target is Enemy or target is Player:
			target.stats.block += amount
