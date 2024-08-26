extends IMob

var metadata_position = [Vector2(600, 300), Vector2(600, 900), 
						Vector2(1800, 300), Vector2(1800, 900)]

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		attack = $spells/attack_mg
		animation = $anim_monster_gem
		collision_shape = $CollisionShape2D as CollisionShape2D
		await super._ready()

func attack_back():
	super.attack_back()
	pass

func die(heros_dealing_dmg):
	super.die(heros_dealing_dmg)
	spells_placeholder.gem_dropped.dropped(self, heros_dealing_dmg)

func bonus(heros_dealing_dmg):
	ServiceScenes.items.number_orb_value(int(ServiceScenes.items.number_orb.text) + 1)
	
func post_dp_script(id, nbr_dupl):
	self.position = metadata_position[id - 1]
