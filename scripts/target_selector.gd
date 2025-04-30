extends Node2D

const POINTS := 1

@onready var area_2d: Area2D = $Area2D
@onready var target_line: Line2D = $CanvasLayer/TargetLine

var current_card: CardUI
var targeting := false

func _ready() -> void:
	Events.card_aim_begin.connect(_on_card_aim_begin)
	Events.card_aim_end.connect(_on_card_aim_end)
	target_line.visible = false

func _process(_delta: float) -> void:
	if not targeting:
		return
	
	area_2d.position = get_local_mouse_position()
	target_line.points = _get_points()

func _get_points() -> Array:
	var points := []
	var start := current_card.global_position
	start.x += (current_card.size.x / 2)
	var target := get_local_mouse_position()
	var distance := target - start
	
	for i in range(POINTS):
		var t := (1.0 / POINTS) * i
		var x := start.x + (distance.x / POINTS) * i
		var y := start.y + ease_out_cubic(t) * distance.y
		points.append(Vector2(x, y))
	
	points.append(target)
	return points

func ease_out_cubic(number: float) -> float:
	return 1.0 - pow(1.0 - number, 3.0)

func _on_card_aim_begin(card: CardUI) -> void:
	if not card.card.is_single_targeted():
		return
	
	targeting = true
	area_2d.monitoring = true
	area_2d.monitorable = true
	target_line.visible = true
	current_card = card

func _on_card_aim_end(_card: CardUI) -> void:
	targeting = false
	target_line.clear_points()
	area_2d.position = Vector2.ZERO
	area_2d.monitoring = false
	area_2d.monitorable = false
	target_line.visible = false
	current_card = null

func _on_area_enter(area: Area2D) -> void:
	if not current_card or not targeting:
		return
	
	if not current_card.targets.has(area):
		current_card.targets.append(area)

func _on_area_exit(area: Area2D) -> void:
	if not current_card or not targeting:
		return
	
	current_card.targets.erase(area)
