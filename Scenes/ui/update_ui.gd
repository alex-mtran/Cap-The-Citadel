class_name Update_UI
extends HBoxContainer

var attack_damage_bonus: int = 0
var defense_armor_bonus: int = 0

@onready var attack_defense: Label = $Attack_Defense

func _ready():
	update_stat_label()

func update_stat_label():
	$Attack_Defense.text = "Attack: +" + str(GameManager.get_attack_bonus()) + " Defense: +" + str(GameManager.get_defense_bonus())
	
func apply_card_effect(attack_increase: int, defense_increase: int):
	attack_damage_bonus += attack_increase
	defense_armor_bonus += defense_increase
	update_stat_label()
	
