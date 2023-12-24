extends AnimatedSprite2D

var animations
const SHADOW_SIZE = 30

func _ready():
	animations = get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func duplicate_shadow(name, position, distance):
	var MULTIPSYNC = get_parent().get_parent().get_node('MultiplayerSynchronizer')
	var shadow = self.duplicate()
	
	shadow.set_name(name)
	shadow.set_script(preload("res://Game/Scenes/ninja_m/script_shadow.gd"))
	shadow.show()
	shadow.global_position = position
	
	animations.add_child(shadow)
	
func get_shadow_clicked(mouse_position):
	var shadow = animations.get_children().filter(
		func(obj):
			return obj.get_name().begins_with('shadow') && obj.global_position.distance_to(
				mouse_position) < SHADOW_SIZE
	)

	if shadow.size() == 1:
		shadow = shadow[0]
	elif shadow.size() > 1:
		var min_distance = SHADOW_SIZE
		for node in shadow:
			if node.global_position.distance_to(mouse_position) < min_distance:
				min_distance = node.global_position.distance_to(mouse_position)
				shadow = [node]	
	else:
		shadow = null
	
	return shadow
	
#func set_pos(obj, position_base, degres, distance):
#	var angle = deg_to_rad(degres) # Convert 120 degrees to radians
#	var xOffset = distance * cos(angle)
#	var yOffset = distance * sin(angle)
#
#	obj.global_position = position_base + (obj.global_transform.origin + Vector2(xOffset, yOffset))

