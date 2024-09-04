extends IPlaceholderSpells

# Called when the node enters the scene tree for the first time.
func _ready():
	await super._ready()

func orb_additionnal_operations(orb_kind):
	##!! mettre des animations
	if orb_kind != MageOrb.OrbKind.BLUE:
		$spells_mage_f_blue/ctrlr_mage_f_2_blue/dp_mage_f_2_blue.get_children().filter(func(s): return s is IActive).map(
			func(s): s.hide()
		)
	
	$ctrlr_mage_f_1.orb.hide()
