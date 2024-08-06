extends CharacterBody2D

class_name IPhysicalSpell

var service_time = preload("res://Game/Services/service_time.gd").new()
var func_on_hit: Array[Callable] = []

var player_hitted
var ennemies_in = []
var spells_retrigger = {}
var cshape

var CONF_DETECT_WITH

func _ready():
	CONF_DETECT_WITH = ServiceScenes.allEnnemiesNode if CONF_DETECT_WITH == null else CONF_DETECT_WITH
	self.visibility_changed.connect(func(): get_node('CollisionShape2D').disabled = !self.visible)

func on_hit(ennemy): #FAIRE LES DEGATS
	player_hitted = ennemy
	for fc in func_on_hit:
		var node = fc.get_object()
		fc.call()

# FONCTIONS SUR LES COLLISIONS 
func _on_body_entered(heros: Node2D):
	pass

func collision():
	for player in CONF_DETECT_WITH:
		if self.visible && player.visible && self.global_position.distance_to(player.position) < (cshape.shape.radius * 2):
			send_damage(player)

func send_damage(player):
	Servrpc.send_to_id(player.get_multiplayer_authority(), player, 'hitted', [self]) # heros hitted BY ennemy spell
	self.on_hit(player)

