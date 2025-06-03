extends EnemyAction

@export var initial_health := 50


func _process(_delta: float) -> void:
	if not enemy:
		return
	initial_health = enemy.stats.health

func is_performable() -> bool:
	if not enemy:
		return false
	var cower : bool = enemy.stats.health < initial_health

	return cower

func perform_action() -> void: 
	if not enemy or not target: 
		return
	
	var tween := create_tween().set_trans(Tween.TRANS_QUINT)
	var start := enemy.global_position
	var end := enemy.global_position + Vector2.RIGHT * 32

	tween.set_loops(1)
	tween.tween_callback(func(): enemy.sprite_2d.flip_h = true)
	tween.tween_property(enemy, "global_position", end, 0.4)
	tween.tween_callback(func(): enemy.sprite_2d.flip_h = false)
	tween.tween_interval(0.3)
	tween.tween_callback(func(): enemy.sprite_2d.flip_h = true)
	tween.tween_interval(0.5)
	tween.tween_callback(func(): enemy.sprite_2d.flip_h = false)
	tween.tween_property(enemy, "global_position", start, 0.4)
	
	tween.finished.connect(
		func():
			Events.enemy_action_completed.emit(enemy)
	)
