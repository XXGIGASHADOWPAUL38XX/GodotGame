extends Node

class_name CustomResourceLoader

static func await_resource_loaded(c: Callable, retry_timeout: float=0.05):
	while c.get_object() != null && !c.call():
		print(c.get_object())
		await c.get_object().get_tree().create_timer(retry_timeout).timeout
		
	return true
