extends IPhysical

class_name IPhysicalSpell

var func_on_hit: Array[Callable] = []

var player_hitted
var ennemies_in = []
var spells_retrigger = {}
var cshape

@export var damage_base: float
var output_damage = Callable(output_damage_f)
@export var champion: IEntity

@export var state_action: State.StateAction = State.StateAction.NULL
@export var state_duration: float = 1.0

var CONF_DETECT_WITH

func _ready():
	await super._ready()
	Servrpc.any(self, 'champion_hitting', [])
	
	CONF_DETECT_WITH = ServiceScenes.allEnnemiesNode if CONF_DETECT_WITH == null else CONF_DETECT_WITH
	gestion_collision()
	

func gestion_collision():
	self.get_node("CollisionShape2D").disabled = !self.visible
	self.visibility_changed.connect(func(): if not self.visible:
		self.get_node("CollisionShape2D").disabled = true
	)
	
	self.animation.frame_changed.connect(func(): 
		if animation.frame == animation.sprite_frames.get_frame_count(animation.animation) - 1 and self.visible:
			self.get_node("CollisionShape2D").disabled = false
			collision()
		else:
			self.get_node("CollisionShape2D").disabled = true
	)

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
		if self.visible && player.visible && self.global_position.distance_to(player.position) < (
			self.get_node("CollisionShape2D").shape.radius * 2):
			send_damage(player)

func send_damage(player):
	Servrpc.send_to_id(player.get_multiplayer_authority(), player, 'hitted', [self]) # heros hitted BY ennemy spell
	self.on_hit(player)

func champion_hitting(node: Node = self):
	if node is IEntity:
		champion = node
		return null
	if node.get_parent() != null:
		return champion_hitting(node.get_parent())
		
	return null
