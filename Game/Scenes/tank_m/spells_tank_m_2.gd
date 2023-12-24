extends "res://Game/Interface/IDamagingSpell.gd"

var champion
var cd_spell = 8.0
var animation: AnimatedSprite2D
var coltdown_spell: Timer
var HUD
var passive

const timer_key_release_cd = 2
var timer_key_release = Timer.new()
var key_released_bool = false
signal key_released

func _ready():
	if is_multiplayer_authority():
		super._ready()
		champion = ServiceScenes.championNode
		animation = $anim_tank_m_2
		coltdown_spell = service_time.init_timer(self, cd_spell)
	
func _process(_delta):
	if is_multiplayer_authority():
		if Input.is_key_pressed(KEY_Z):
			if coltdown_spell.time_left == 0:
				timer_key_release = service_time.init_timer(self, timer_key_release_cd)
				timer_key_release.timeout.connect(spell_stop)
				timer_key_release.start()
				key_released_bool = true
				
				coltdown_spell.start()
				spell_start()
		elif key_released_bool == true:
			key_released.emit()
			
		if self.visible:
			self.position = champion.position

		if (HUD == null):
			HUD = ServiceScenes.getMainScene().get_node('stats_heros')
		else:
			HUD.bindTo(coltdown_spell, 2)
		
func spell_start():
	self.show()
	animation.play('default')

func spell_stop():
	self.hide()
	animation.stop()
	if timer_key_release.timeout.is_connected(spell_stop):
		timer_key_release.timeout.disconnect(spell_stop)

func _on_key_released():
	spell_stop()
