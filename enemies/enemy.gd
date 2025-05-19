class_name Enemy
extends Area2D

const ARROW_OFFSET := -15

@export var stats: Enemy_Stats : set = set_enemy_stats

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var arrow: Sprite2D = $Arrow
@onready var stats_ui: StatsUI = $StatsUI as StatsUI
@onready var intent_ui: IntentUI = $IntentUI as IntentUI
@onready var sfx_enemy: AudioStreamPlayer = $HitSFX

var enemy_action_picker: Enemy_Action_Picker
var current_action: Enemy_Action : set = set_current_action

func set_current_action(value: Enemy_Action) -> void:
	current_action = value
	if current_action:
		intent_ui.update_intent(current_action.intent)
	
# Test
# func _ready() -> void:
# 	await get_tree().create_timer(2).timeout
# 	take_damage(6)
# 	stats.block += 8
			
func set_enemy_stats(value: Enemy_Stats) -> void:
	stats = value.create_instance()

	if not stats.stats_changed.is_connected(update_stats):
		stats.stats_changed.connect(update_stats)
		stats.stats_changed.connect(update_action)

	update_enemy()
func setup_ai() -> void: 
	if enemy_action_picker:
		enemy_action_picker.queue_free()
		
	var new_action_picker: Enemy_Action_Picker = stats.ai.instantiate()
	add_child(new_action_picker)
	enemy_action_picker = new_action_picker
	enemy_action_picker.enemy = self
	
func update_stats() -> void:
	stats_ui.update_stats(stats)

func update_action() -> void:
	if not enemy_action_picker:
		return
	if not current_action:
		current_action = enemy_action_picker.get_action()
		return
	var new_conditional_action := enemy_action_picker.get_first_conditional_action()
	if new_conditional_action and current_action != new_conditional_action:
		current_action = new_conditional_action


func update_enemy() -> void:
	if not stats is Stats:
		return
	if not is_inside_tree():
		await ready

	sprite_2d.texture = stats.art
	arrow.position = Vector2.RIGHT * (sprite_2d.get_rect().size.x / 2 + ARROW_OFFSET)
	setup_ai()
	update_stats()

func do_turn() -> void:
	stats.block = 0
	
	if not current_action:
		return
	current_action.perform_action()
	
func take_damage(damage: int) -> void:
	sfx_enemy.play()
	
	if stats.health <= 0:
		return

	var tween := create_tween()
	tween.tween_callback(Shaker.shake.bind(self, 16, 0.15))
	tween.tween_callback(stats.take_damage.bind(damage))
	tween.tween_interval(0.2)
	
	tween.finished.connect(
		func():
			if stats.health <= 0:
				queue_free()
	)
"""
	stats.take_damage(damage)

	if stats.health <= 0:
		queue_free()
"""

func _on_area_entered(_area: Area2D) -> void:
	arrow.show()

func _on_area_exited(_area: Area2D) -> void:
	arrow.hide()

	
	
