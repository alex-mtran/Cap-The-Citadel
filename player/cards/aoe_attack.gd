# meta_description: What happens when a card is played.
extends Card


func apply_effects(targets: Array[Node]) -> void:
	var damage_effect := DamageEffect.new()
	var total_damage = 3 + GameManager.get_attack_bonus()
	damage_effect.amount = total_damage
	damage_effect.execute(targets)

func dynamic_tooltip() -> String:
	var total_damage = 3 + GameManager.get_attack_bonus()
	return "[center]Deal[color=\"ff0000\"] %d[/color] damage to all enemies.[/center]" % total_damage
