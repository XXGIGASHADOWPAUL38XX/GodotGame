extends IMob

# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_multiplayer_authority(Server.get_first_player_connected_id())
	if is_multiplayer_authority():
		attack = $spells/attack_golem
		animation = $boss_golem_anim
		collision_shape = $CollisionShape2D as CollisionShape2D
		self.position = Vector2(get_window().size.x, get_window().size.y)
		await super._ready()

func attack_back():
	super.attack_back()
	pass

func die(heros_dealing_dmg):
	super.die(heros_dealing_dmg)
	ServiceAnnounce.set_announce(
		heros_dealing_dmg.name + 'has defeated the golem boss',
		'res://Game/Ressources/Heros/icons/' + heros_dealing_dmg.name + '.png',
		'res://Game/Ressources/Main_Effects/Boss/boss_golem/logo.png'
	)

func bonus():
	ServiceScenes.alliesNode.map(func(obj): obj.get_node('shield').set_shield(20, 10))
	
	
