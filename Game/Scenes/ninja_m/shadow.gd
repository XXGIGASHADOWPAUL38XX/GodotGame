extends ICollision

var is_shadow = true

func _ready():
	if is_multiplayer_authority():
			super._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func active(shuriken):
	self.position = shuriken.position
	self.show()
	
func is_active():
	return self.visible
	
func has_been_dashed_to():
	self.hide()
	
func dash():
	pass
	
#func get_shadow_clicked(mouse_position):
	#var shadow = animations.get_children().filter(
		#func(obj):
			#return obj.get_name().begins_with('shadow') && obj.global_position.distance_to(
				#mouse_position) < SHADOW_SIZE
	#)
#
	#if shadow.size() == 1:
		#shadow = shadow[0]
	#elif shadow.size() > 1:
		#var min_distance = SHADOW_SIZE
		#for node in shadow:
			#if node.global_position.distance_to(mouse_position) < min_distance:
				#min_distance = node.global_position.distance_to(mouse_position)
				#shadow = [node]	
	#else:
		#shadow = null
	#
	#return shadow
#
