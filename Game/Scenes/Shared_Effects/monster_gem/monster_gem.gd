extends "res://Game/Interface/IMob.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_multiplayer_authority(Server.get_first_player_connected_id())
	if is_multiplayer_authority():
		attack = get_node('attack_mg')
		animation = $anim_monster_gem
		collision_shape = $CollisionShape2D as CollisionShape2D
		self.position = Vector2(300, 300)
		super._ready()

func attack_back():
	super.attack_back()
	pass

func die(heros_dealing_dmg):
	super.die(heros_dealing_dmg)
	pass

func bonus():
	pass
	
	
