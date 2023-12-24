extends "res://Game/Interface/IDamagingSpell.gd"

var speed = 10.0
var champion
var cd_spell = 15.0
var animation: AnimatedSprite2D
var coltdown_spell: Timer
var HUD

var charge_animation

func _ready():
	if is_multiplayer_authority():
		super._ready()

		champion = ServiceScenes.championNode
		animation = $anim_tank_m_4
		coltdown_spell = service_time.init_timer(self, cd_spell)
		
		charge_animation = get_parent().get_node('animations').get_node('spell4_charge')
		
		self.body_entered.connect(func(obj): if obj.visible && obj == get_parent().get_node(
			'rock_tank_m_3') && obj.get_node('anim_tank_m_3').frame == 6:
			self.hide()
			get_parent().get_node('spells_exp_tank_m_3').explode()
		)
		
		self.visibility_changed.connect(func(): charge_animation.visible = self.visible)

func _process(_delta):
	if is_multiplayer_authority():
		if Input.is_key_pressed(KEY_SPACE) && coltdown_spell.time_left == 0:
			coltdown_spell.start()
			spell_launch()
			
		if (HUD == null):
			HUD = ServiceScenes.getMainScene().get_node('stats_heros')
		else:
			HUD.bindTo(coltdown_spell, 4)

func spell_launch():
	charge_animation.charge()
	
	var direction = (get_global_mouse_position() - champion.position).normalized()
	self.position = champion.position + ServiceSpell.set_in_front_mouse(champion, 
		get_global_mouse_position(), 30)
	self.rotation = (self.position - champion.position).angle()
	champion.set_attribute('speed', 0, 1)

	self.show()
	
	for i in range(40):
		if self.visible:
			self.position += (direction * speed)
			champion.position = self.position + ServiceSpell.set_in_front(self, -20)
			await get_tree().create_timer(0.02).timeout
		
	self.hide()

