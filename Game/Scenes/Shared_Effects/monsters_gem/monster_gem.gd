extends IMob

var metadata_position = [Vector2(466, 468), Vector2(466, 2048), 
						Vector2(2054, 468), Vector2(2054, 2048)]

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		attack = $spells/attack_mg
		collision_shape = $CollisionShape2D as CollisionShape2D
		
	await super._ready()

func attack_back():
	super.attack_back()
	pass

func die(heros_dealing_dmg):
	super.die(heros_dealing_dmg)
	spells_placeholder.gem_dropped.dropped(self, heros_dealing_dmg)

func bonus(heros_dealing_dmg):
	ServiceScenes.shop.number_orb_value(int(ServiceScenes.shop.number_orb.text) + 1)
	
func post_dp_script(id, nbr_dupl):
	self.position = metadata_position[id - 1]
