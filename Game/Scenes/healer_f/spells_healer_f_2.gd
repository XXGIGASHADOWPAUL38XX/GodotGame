extends "res://Game/Interface/IDamagingSpell.gd"

var champion
var cd_spell = 8.0
var animation: AnimatedSprite2D
var coltdown_spell: Timer
var HUD
var passive
var modulate_bool = false

func _ready():
	if is_multiplayer_authority():
		CONF_DETECT_WITH = ServiceScenes.alliesNode
		super._ready()
		self.hide()
		
		champion = ServiceScenes.championNode
		animation = $spells_healer_f_2_anim
		coltdown_spell = service_time.init_timer(self, cd_spell)

func _process(_delta):
	if is_multiplayer_authority():
		modulate_bool = await ServiceSpell.modulate_obj(self, modulate_bool)
		if Input.is_key_pressed(KEY_Z) && coltdown_spell.time_left == 0:
			coltdown_spell.start()
			spell2_heal()
			
		if (HUD == null):
			HUD = ServiceScenes.getMainScene().get_node('stats_heros')
		else:
			HUD.bindTo(coltdown_spell, 2)
			
		
func spell2_heal():
	self.position = ServiceSpell.distance_range_max(champion.position, get_global_mouse_position(), 300)
	self.show()
	animation.play("default")
		
	await get_tree().create_timer(3).timeout
	animation.stop()
	self.hide()
	
func heal(heros):
	champion.take_damage(-2, State.StateMovement.NULL)
	await get_tree().create_timer(0.2).timeout
