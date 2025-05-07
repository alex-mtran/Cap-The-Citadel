class_name Enemy
extends Area2D

const ARROW_OFFSET := -15

@export var stats: Stats : set = set_enemy_stats

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var arrow: Sprite2D = $Arrow
@onready var stats_ui: StatsUI = $StatsUI as StatsUI

# Test
# func _ready() -> void:
# 	await get_tree().create_timer(2).timeout
# 	take_damage(6)
# 	stats.block += 8

var turn_index := 0
var behavior: Array = []

func get_intent_text() -> void:
	#var a = get_current_behavior()
	match EnemyBase.EnemyType:
		EnemyBase.EnemyType.BASIC:
			behavior = [
				{ "type": EnemyBase.BehaviorType.ATTACK, "value": 6 },
				{ "type": EnemyBase.BehaviorType.DEFEND, "value": 5 }
			]
		EnemyBase.EnemyType.ELITE:
			behavior = [
				{ "type": EnemyBase.BehaviorType.ATTACK, "value": 6 },
				{ "type": EnemyBase.BehaviorType.DEFEND, "value": 5 },
				{ "type": EnemyBase.BehaviorType.BUFF, "value": 2 },
				{ "type": EnemyBase.BehaviorType.DEBUFF, "value": 8 }
			]
		EnemyBase.EnemyType.BOSS:
			behavior = [
				{ "type": EnemyBase.BehaviorType.ATTACK, "value": 8 },
				{ "type": EnemyBase.BehaviorType.DEFEND, "value": 5 },
				{ "type": EnemyBase.BehaviorType.BUFF, "value": 2 }
			]
			
func set_enemy_stats(value: Stats) -> void:
	stats = value.create_instance()

	if not stats.stats_changed.is_connected(update_stats):
		stats.stats_changed.connect(update_stats)

	update_enemy()

func update_stats() -> void:
	stats_ui.update_stats(stats)

func update_enemy() -> void:
	if not stats is Stats:
		return
	if not is_inside_tree():
		await ready

	sprite_2d.texture = stats.art
	arrow.position = Vector2.RIGHT * (sprite_2d.get_rect().size.x / 2 + ARROW_OFFSET)
	update_stats()

func take_damage(damage: int) -> void:
	if stats.health <= 0:
		return

	stats.take_damage(damage)

	if stats.health <= 0:
		queue_free()

func act_on_player(player: Node) -> void:
	if behavior.is_empty():
		return

	var curr = behavior[turn_index % behavior.size()]
	match curr.type:
		EnemyBase.BehaviorType.ATTACK:
			player.take_damage(curr.value)
		EnemyBase.BehaviorType.DEFEND:
			stats.block += curr.value
		EnemyBase.BehaviorType.BUFF:
			stats.attack += curr.value
		EnemyBase.BehaviorType.DEBUFF:
			player.stats.attack -= curr.value

	turn_index += 1
	
func _on_area_entered(_area: Area2D) -> void:
	arrow.show()

func _on_area_exited(_area: Area2D) -> void:
	arrow.hide()
	
	
	
