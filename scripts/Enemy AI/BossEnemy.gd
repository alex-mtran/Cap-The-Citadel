extends EnemyBase

class_name BossEnemy
	
func _ready():
	type = EnemyType.BOSS
	behavior = [
		{ "type": BehaviorType.ATTACK, "value": 8 },
		{ "type": BehaviorType.DEFEND, "value": 5 },
		{ "type": BehaviorType.BUFF, "value": 2 }
	]
