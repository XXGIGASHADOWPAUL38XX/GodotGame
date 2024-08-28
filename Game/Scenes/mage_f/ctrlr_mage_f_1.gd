extends IControllerKeyPressed

var anim_orb_hide
var orb

func after_ready():
	key = KEY_A
	coltdown_time = 4
	
	anim_orb_hide = $anim_orb_hide
	orb = $spells_mage_f_1
	
	await super.after_ready()
			
func active():
	super.active()
	orb.can_active()
	
