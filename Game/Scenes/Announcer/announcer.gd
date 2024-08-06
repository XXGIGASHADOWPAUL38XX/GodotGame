extends Control

var camera
var announce_y_offset = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if camera == null:
		camera = ServiceScenes.getCamera()
	else:
		self.position = Vector2(camera.offset.x, camera.offset.y + announce_y_offset)

func set_announce(announce, logo_left, logo_right, champion=null): #RELATIVE = RELATIVE TO ONE SPECIFIC PLAYER 
	
	position_announce()
	
	$HBoxContainer/Label.text = announce
	
	if !(champion in ServiceScenes.players):
		$HBoxContainer/Label.add_theme_color_override('font_color', Color.WHITE)
	elif ServiceScenes.is_on_same_team(ServiceScenes.champion, champion):
		$HBoxContainer/Label.add_theme_color_override('font_color', Color.BLUE)
	else:
		$HBoxContainer/Label.add_theme_color_override('font_color', Color.RED)

	
	$HBoxContainer/Logo_left.texture = load(logo_left)
	$HBoxContainer/Logo_right.texture = load(logo_right)
	show_announcer()
	
	await get_tree().create_timer(2).timeout
	hide_announcer()
	
func show_announcer():
	self.modulate.a = 0
	self.show()
	
	for i in range(10):
		self.modulate.a += 0.1
		await get_tree().create_timer(0).timeout

func hide_announcer():
	for i in range(10):
		self.modulate.a -= 0.1
		await get_tree().create_timer(0).timeout
		
	self.hide()
	self.queue_free()
	
func position_announce():
	var existing_announce = ServiceScenes.getMainScene().get_children().filter(
		func(obj):
			return obj.get_name().find('@announcer') != -1
	)
	
	announce_y_offset = (existing_announce.size() - 1) * 50
	
