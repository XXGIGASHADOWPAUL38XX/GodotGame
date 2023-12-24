extends "res://Game/Interface/IMob.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_multiplayer_authority(Server.get_first_player_connected_id())
	if is_multiplayer_authority():
		attack = $attack_crystal
		animation = $anim_boos_crystal
		collision_shape = $CollisionShape2D as CollisionShape2D
		self.position = Vector2(get_window().size.x, get_window().size.y)
		super._ready()

func attack_back():
	super.attack_back()
	pass

func die(heros_dealing_dmg):
	super.die(heros_dealing_dmg)
	ServiceAnnounce.set_announce(
		heros_dealing_dmg.name + 'has defeated the crystal boss',
		'res://Game/Ressources/Heros/icons/' + heros_dealing_dmg.name + '.png',
		'res://Game/Ressources/Main_Effects/Foozle_2DE0001_Pixel_Magic_Effects/Crystal Knight/logo.png'
	)

func bonus():
	pass
	
	
