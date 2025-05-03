#if the player clicks the button for the end player turn, then the enemy ends up attacking

class_name EnemyIntent
extends CharacterBody2D

enum Type {CONDITIONAL, CHANCE_BASED}

@export var type: Type
@export_range(0.0, 10.0) var chance_weight := 0.0

@onready var accumulated_weight := 0.0

var enemy: SceneMultiplayer
