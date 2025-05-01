extends EnemyBase

class_name BasicEnemy
	
func _ready():
	type = EnemyType.BASIC
	behavior = [
		{ "type": BehaviorType.ATTACK, "value": 6 },
		{ "type": BehaviorType.DEFEND, "value": 5 },
	]
