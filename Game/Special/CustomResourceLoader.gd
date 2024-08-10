extends Node

class_name CustomResourceLoader

func await_resource_loaded(c: Callable, retry_timeout: float=0.05):
	while c.get_object() != null && !c.call():
		await c.get_object().get_tree().create_timer(retry_timeout).timeout
