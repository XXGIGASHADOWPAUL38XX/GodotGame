extends IPhysical

class_name IPhysicalSpell

var func_on_hit: Array[Callable] = []

var player_hitted
var ennemies_in = []
var spells_retrigger = {}
var cshape

@export var damage_base: float
var output_damage = Callable(output_damage_f)

var CONF_DETECT_WITH

func after_ready():
	await super.after_ready()
	
	CONF_DETECT_WITH = ServiceScenes.allEnnemiesNode if CONF_DETECT_WITH == null else CONF_DETECT_WITH
	self.visibility_changed.connect(func(): get_node('CollisionShape2D').disabled = !self.visible)

func on_hit(ennemy): #FAIRE LES DEGATS
	player_hitted = ennemy
	for fc in func_on_hit:
		var node = fc.get_object()
		fc.call()

func output_damage_f(champion_hitted):
	return damage_base

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

