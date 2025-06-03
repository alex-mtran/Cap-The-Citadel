extends Card

#Create a test to see if the basic attack works
#test
# func test_basic_attack_does_it_work()
	# var target = Enemy.new()
	# target.stats = Stats.new()
	# target.stats.health = 5
	# var choose_card = card.new()
	# choose_card.apply_effects([target])
	# assert_eq(target.stats.health, 3, "Health should decrease by 2 after function is run")

func apply_effects(targets: Array[Node]) -> void:
	var damage_effect := DamageEffect.new()
	var total_damage = 4 + GameManager.get_attack_bonus()
	damage_effect.amount = total_damage
	damage_effect.execute(targets)

func dynamic_tooltip() -> String:
	var total_damage = 4 + GameManager.get_attack_bonus()
	return "[center]Deal[color=\"ff0000\"] %d[/color] damage.[/center]" % total_damage