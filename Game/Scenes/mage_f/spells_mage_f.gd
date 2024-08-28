extends IPlaceholderSpells

# Called when the node enters the scene tree for the first time.
func after_ready():
	await super.after_ready()

func orb_additionnal_operations(orb_kind):
	##!! mettre des animations
	if orb_kind != MageOrb.OrbKind.BLUE:
		$spells_mage_f_blue/ctrlr_mage_f_2_blue/dp_mage_f_2_blue.get_children().filter(func(s): return s is IActive).map(
			func(s): s.hide()
		)
		
	if $ctrlr_mage_f_1.orb.visible:
		$ctrlr_mage_f_1.anim_orb_hide.can_active()
	
	$ctrlr_mage_f_1.orb.hide()
