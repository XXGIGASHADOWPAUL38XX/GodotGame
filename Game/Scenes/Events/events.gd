extends Control

var actual_round = 0
var local_won_rounds = 0

var LIST_EVENTS = ['stones', 'stones', 'stones', 'stones', 'stones']
var all_events = []
var current_event

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		display_events()
		Servrpc.any(self, 'new_event', [])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position = ServiceScenes.camera.offset

func new_round(victory: bool):
	actual_round += 1
	
	var styleBox: StyleBoxFlat = $Events.get_node("Event" + str(actual_round)).get_theme_stylebox('panel').duplicate()
	styleBox.border_color = Color.BLUE if victory else Color.RED
	$Events.get_node("Event" + str(actual_round)).add_theme_stylebox_override('panel', styleBox)
	
	var test = $Events.get_node("Event1") as Panel
	
	new_event()

func new_event():
	while all_events.size() == 0:
		await get_tree().create_timer(0).timeout
	
	if actual_round != 0:
		var scene_to_delete = ServiceScenes.main_scene.get_children().filter(
			func(obj): return obj.name == current_event
		)[0]
		scene_to_delete.queue_free()
		ServiceScenes.main_scene.remove_child(scene_to_delete)
	
	current_event = all_events[actual_round]
	var new_event_scene = load("res://Game/Scenes/Events/" + current_event + "/"  + current_event + ".tscn").instantiate()
	new_event_scene.set_multiplayer_authority(Server.get_first_player_connected_id())
	
	ServiceScenes.main_scene.add_child(new_event_scene)

func display_events():
	for i in range(5):
		var event = LIST_EVENTS[randi_range(0, LIST_EVENTS.size() - 1)]
		LIST_EVENTS.remove_at(LIST_EVENTS.find(event))
		all_events.append(event)
		
	Servrpc.any(self, 'sync_events', [all_events])
		
func sync_events(all_events_server):
	if all_events.size() == 0:
		all_events = all_events_server
	for i in range(all_events.size()):
		$Events.get_node('Event' + str(i + 1)).get_node('TextureRect').texture = load(
		"res://Game/Ressources/Events/" + all_events[i] + ".png")

