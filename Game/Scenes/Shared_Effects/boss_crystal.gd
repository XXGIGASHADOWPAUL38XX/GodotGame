extends IMob

const SCENE_BONUS_PATH = "res://Game/Scenes/Shared_Effects/shield_boss_crystal.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		attack = $spells/attack_crystal
		collision_shape = $CollisionShape2D as CollisionShape2D
		self.position = Vector2(ServiceWindow.scene_size.x / 2, ServiceWindow.scene_size.y / 2)
		
	await super._ready()

func attack_back():
	super.attack_back()
	pass

func die(heros_dealing_dmg):
	ServiceAnnounce.set_announce(
		heros_dealing_dmg.name + 'has defeated the crystal boss',
		'res://Game/Ressources/Heros/hud_icons/' + heros_dealing_dmg.name + '.png',
		'res://Game/Ressources/Main_Effects/Foozle_2DE0001_Pixel_Magic_Effects/Crystal Knight/logo.png'
	)
	
	super.die(heros_dealing_dmg)
	
	get_parent().queue_free()

func bonus(heros_dealing_dmg):
	var allies_of_heros_dmg = ServiceScenes.entities.alliesNode if ServiceScenes.is_on_same_team(
	heros_dealing_dmg, ServiceScenes.championNode) else ServiceScenes.entities.ennemiesNode
	
	allies_of_heros_dmg.map(func(ally): 
		var scene_bonus = preload(SCENE_BONUS_PATH).duplicate().instantiate()
		scene_bonus.set_multiplayer_authority(ally.get_multiplayer_authority())
		ally.add_child(scene_bonus)
	)
