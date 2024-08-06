extends IControllerSpell

func _ready():
	key = KEY_A
	coltdown_time = 4
	await super._ready()

func _process(_delta):
	if is_multiplayer_authority():
		super._process(_delta)
		if (HUD == null):
			HUD = ServiceScenes.getMainScene().get_node('stats_heros')
		else:
			HUD.bindTo(coltdown, 1)
			
func active():
	$spells_mage_f_1.active()
	coltdown.start()
