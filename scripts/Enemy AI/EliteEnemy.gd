extends EnemyBase

class_name EliteEnemy
	

func _ready():
	type = EnemyType.ELITE
	behavior = [
		{ "type": BehaviorType.ATTACK, "value": 6 },
		{ "type": BehaviorType.DEFEND, "value": 5 },
		{ "type": BehaviorType.BUFF, "value": 2 },
		{ "type": BehaviorType.DEBUFF, "value": 8 }
	]
