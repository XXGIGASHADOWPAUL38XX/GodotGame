extends Node

var portal_1: Area2D
var portal_2: Area2D

var dict_champ_portal = {}
var animation_duration

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		portal_1 = $teleporter
		portal_2 = $teleporter2
		
		animation_duration = ServiceSpell.animation_duration($teleporter/teleporter_anim)
		
		portal_1.body_entered.connect(portal_entered.bind(portal_1, portal_2))
		portal_2.body_entered.connect(portal_entered.bind(portal_2, portal_1))
		
		portal_1.body_exited.connect(portal_exited.bind(portal_1, portal_2))
		portal_2.body_exited.connect(portal_exited.bind(portal_2, portal_1))
		
		for player in ServiceScenes.allPlayersNode:
			dict_champ_portal[player] = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	if is_multiplayer_authority():
#		ServiceSpell.modulate_obj(portal_1)
#		ServiceSpell.modulate_obj(portal_2)

func portal_entered(node_body, portal_emit, portal_to_send):
	if not node_body is IHeros or dict_champ_portal[node_body] == false:
		return
	
	if dict_champ_portal.get(node_body):
		var temp_speed_champion = node_body.speed_final
		var animation_portal = portal_emit.get_node('teleporter_anim')
		if !animation_portal.animation_finished.is_connected(tp_to_portal):
			animation_portal.animation_finished.connect(tp_to_portal.bind(
				node_body, animation_portal, portal_to_send))
		
		Servrpc.send_to_id(node_body.get_multiplayer_authority(), node_body, 'add_state', 
		[self, 'states_action', State.StateAction.CONCENTRATE, animation_duration])
		
		animation_portal.play('default')

func portal_exited(node_body, current_portal, other_portal):
	dict_champ_portal[node_body] = true

func tp_to_portal(champion, animation_portal, portal_to_send):
	dict_champ_portal[champion] = false
	animation_portal.animation_finished.disconnect(tp_to_portal)
	ServiceAnimations.set_animation(champion, 'animation_portal')
	
	Servrpc.send_to_id(champion.get_multiplayer_authority(), self, 'tp_to_portal_remote', 
	[champion, portal_to_send.global_position])

func tp_to_portal_remote(champion, portal_position):
	champion.position = portal_position
