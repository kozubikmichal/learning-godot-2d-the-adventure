extends Marker2D
class_name SwitchPuzzleManager

signal puzzle_solved
signal puzzle_failed

@export var correct_switches: Array[Switch] = []
@export var incorrect_switches: Array[Switch] = []

var score: int = 0
var target_score: int = 0

func _ready() -> void:
	target_score = correct_switches.size()
	for switch in correct_switches:
		switch.switch_activated.connect(increment_score)
		switch.switch_deactivated.connect(decrement_score)

	for switch in incorrect_switches:
		switch.switch_activated.connect(decrement_score)
		switch.switch_deactivated.connect(increment_score)

func increment_score() -> void:
	score += 1
	if score >= target_score:
		puzzle_solved.emit()

func decrement_score() -> void:
	score -= 1
	if score < target_score:
		puzzle_failed.emit()
