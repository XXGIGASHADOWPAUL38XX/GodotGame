extends Node

#class_name CustomResourceLoader
#
#static func await_resource_loaded(root, c: Callable, retry_timeout: float=0.01):
	#var thread = Thread.new()
	#thread.start(Callable(func(): await thread_res_loaded(root, c, retry_timeout)))
	#await thread.wait_to_finish()
#
#static func thread_res_loaded(root, c, retry_timeout):
	#var service_time = preload("res://Game/Services/service_time.gd").new()
	#var timer: Timer = service_time.init_timer(root, retry_timeout)
	#
	#while !c.call():
		#print(root)
		#timer.start()
		#await timer.timeout
		#
	#return true
	#
