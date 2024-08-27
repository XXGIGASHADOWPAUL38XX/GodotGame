extends IControllerKeyPressed

var anim_orb_hide
var orb

func _ready():
	key = KEY_A
	coltdown_time = 4
	
	anim_orb_hide = $anim_orb_hide
	orb = $spells_mage_f_1
	
	await super._ready()
			
func active():
	super.active()orb.active()
	
