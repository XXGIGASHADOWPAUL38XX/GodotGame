class_name ServiceTime

func init_timer(root, coltdown):
	var timer := Timer.new()
	timer.wait_time = coltdown
	root.add_child(timer)
	timer.one_shot = true
	return timer
	
