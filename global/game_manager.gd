extends Node

signal upgrades_changed

var attack_damage_bonus: int = 0
var defense_armor_bonus: int = 0


func add_attack_bonus(amount: int) -> void:
	attack_damage_bonus += amount
	upgrades_changed.emit()

func add_defense_bonus(amount: int) -> void:
	defense_armor_bonus += amount
	upgrades_changed.emit()

func get_attack_bonus() -> int:
	return attack_damage_bonus

func get_defense_bonus() -> int:
	return defense_armor_bonus

func reset_upgrades() -> void:
	attack_damage_bonus = 0
	defense_armor_bonus = 0
	upgrades_changed.emit()
