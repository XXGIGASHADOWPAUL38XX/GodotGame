extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func await_event(callable: Callable, delay=0.05):
	while callable.call() != true:
		await get_tree().create_timer(delay).timeout

