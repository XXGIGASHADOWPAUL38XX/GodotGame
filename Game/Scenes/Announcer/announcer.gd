extends Control

var camera

@onready var label = $VBoxContainer/HBoxContainer/MarginContainer3/Panel_label/Label
@onready var panel_logo_left = $VBoxContainer/HBoxContainer/Panel_left
@onready var panel_logo_rigth = $VBoxContainer/HBoxContainer/Panel_right

@onready var logo_left = $VBoxContainer/HBoxContainer/Panel_left/MarginContainer/Logo_left
@onready var logo_right = $VBoxContainer/HBoxContainer/Panel_right/MarginContainer/Logo_right

var ally_color = Color(0, 1, 1, 0.7)
var ennemy_color = Color(1, 0, 0, 0.7)
var neutral_color = Color(0.7, 0.7, 0.7, 0.7)

var announce_queue = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	ServiceScenes.announcer_scene = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if camera == null:
		camera = ServiceScenes.camera
	else:
		self.position = Vector2(camera.offset.x, camera.offset.y)

func set_announce(announce_text, logo_left_texture, logo_right_texture, champion=null): #RELATIVE = RELATIVE TO ONE SPECIFIC PLAYER 
	print(123)
	var random_id = randf()
	announce_queue[random_id] = Announce.new(announce_text, logo_left_texture, logo_right_texture, champion)
	
	if announce_queue.keys().size() == 1:
		display_announce(random_id, announce_queue[random_id])
	
func display_announce(random_id, announce: Announce):
	print(456)
	label.text = announce.text
	
	if !(announce.champion in ServiceScenes.allPlayersNode):
		panel_logo_left.modulate = neutral_color
		panel_logo_rigth.modulate = neutral_color
	else:
		panel_logo_left.modulate = ally_color if ServiceScenes.is_on_same_team(ServiceScenes.championNode, announce.champion) else ennemy_color
		panel_logo_rigth.modulate = ally_color if ServiceScenes.is_on_same_team(ServiceScenes.championNode, announce.champion) else ennemy_color

	logo_left.texture = load(announce.logo_left)
	logo_right.texture = load(announce.logo_right)
	show_announcer()
	
	await get_tree().create_timer(1).timeout
	await hide_announcer()
	await get_tree().create_timer(0.2).timeout
	
	announce_done(random_id)
	
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

func announce_done(random_id):
	announce_queue.erase(random_id)
	
	if announce_queue.keys().size() != 0:
		var next_announce_key = announce_queue.keys()[0]
		display_announce(next_announce_key, announce_queue[next_announce_key])
	
