extends "res://Game/Interface/IPhysicalSpell.gd"

var champion
var cd_spell = 7.0
var animation: AnimatedSprite2D
var coltdown_spell: Timer
var HUD
var passive

func _ready():
	if is_multiplayer_authority():
		cshape = $anim_tank_m_3
		champion = ServiceScenes.championNode
		animation = $anim_tank_m_3
		animation.animation_finished.connect(func(obj): collision())
		coltdown_spell = service_time.init_timer(self, cd_spell)
		
		self.visibility_changed.connect(func(): get_node('CollisionShape2D').disabled = !self.visible)

func _process(_delta):
	if is_multiplayer_authority():
		if Input.is_key_pressed(KEY_E) && coltdown_spell.time_left == 0:
			coltdown_spell.start()
			spell_fall()
			
		if (HUD == null):
			HUD = ServiceScenes.getMainScene().get_node('stats_heros')
		else:
			HUD.bindTo(coltdown_spell, 3)
		
func spell_fall():
	self.position = ServiceSpell.distance_range_max(champion.position, get_global_mouse_position(), 300)
	self.show()
	animation.play("default")
		
	await get_tree().create_timer(4).timeout
	animation.stop()
	self.hide()
	
	



