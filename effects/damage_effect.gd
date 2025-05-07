class_name DamageEffect
extends Effect

var amount: int = 0

#Test
# Goal: make sure that it applies damage correct for each valid target 
#func test_damage_does_it_work()
	# var target = Enemy.new()
	# target.stats = Stats.new()
	# target.stats.health = 20;
	# var effect = DamageEffect.new()
	# effect.amount = 4
	# effect.execute([target])
	# assert_eq(target.stats.health, 16, "Damage should decrease by 4")
	
func execute(targets: Array[Node]) -> void:
	for target in targets:
		if not target:
			continue
		if target is Enemy or target is Player:
			target.take_damage(amount)
