@icon("res://addons/health/Health.svg")
class_name Health extends Node


signal died()
signal revived()
signal damaged(amount: float, adjusted_amount: float)
signal healed(amount: float, adjusted_amount: float)

@export var total: float = 100.0

@onready var current: float = total


func is_alive() -> bool:
	return current > 0.0


func is_dead() -> bool:
	return not is_alive()


func is_full() -> bool:
	return is_equal_approx(current, total)


func percent() -> float:
	if total <= 0.0:
		return 0.0

	if is_full():
		return 1.0

	return min(current / total, 1)


func damage(amount: float) -> void:
	if is_dead():
		return

	var adjusted_amount = min(current, amount)
	current -= adjusted_amount
	print_debug("{0} - damage amount={1} adjusted={2} current={3}".format([owner, amount, adjusted_amount, current]))

	damaged.emit(amount, adjusted_amount)

	if is_dead():
		died.emit()


func heal(amount: float) -> void:
	if current == total:
		return

	var was_revived = is_dead()
	var adjusted_amount = min(total - current, amount)
	current += adjusted_amount
	print_debug("{0} - heal amount={1} adjusted={2} current={3}".format([owner, amount, adjusted_amount, current]))

	healed.emit(amount, adjusted_amount)

	if was_revived:
		revived.emit()
