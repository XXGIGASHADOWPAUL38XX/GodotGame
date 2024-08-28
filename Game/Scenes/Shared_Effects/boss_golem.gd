extends IMob

const SCENE_BONUS_PATH = "res://Game/Scenes/Shared_Effects/shield_boss_golem.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		attack = $spells/attack_golem
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
	
	await multip_sync.synchronized
	get_parent().queue_free()

func bonus(heros_dealing_dmg):
	var allies_of_heros_dmg = ServiceScenes.alliesNode if ServiceScenes.is_on_same_team(
		heros_dealing_dmg, ServiceScenes.championNode) else ServiceScenes.ennemiesNode
	
	allies_of_heros_dmg.map(func(ally): 
		var scene_bonus = preload(SCENE_BONUS_PATH).duplicate().instantiate()
		scene_bonus.set_multiplayer_authority(ally.get_multiplayer_authority())
		ally.add_child(scene_bonus)
	)
	
	
