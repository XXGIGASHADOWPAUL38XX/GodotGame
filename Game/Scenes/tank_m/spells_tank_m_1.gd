extends "res://Game/Interface/IDamagingSpell.gd"

var speed = 8.0
var champion
var cd_spell1 = 7.0
var animation: AnimatedSprite2D
var coltdown_spell1: Timer
var HUD

func _ready():
	if is_multiplayer_authority():
		super._ready()

		champion = ServiceScenes.championNode
		animation = $anim_tank_m_1
		coltdown_spell1 = service_time.init_timer(self, cd_spell1)
		
		self.body_entered.connect(func(obj): if obj.visible && obj == get_parent().get_node(
			'rock_tank_m_3') && obj.get_node('anim_tank_m_3').frame == 6:
			self.hide()
			get_parent().get_node('spells_exp_tank_m_3').explode()
		)

func _process(_delta):
	if is_multiplayer_authority():
		if Input.is_key_pressed(KEY_A) && coltdown_spell1.time_left == 0:
			coltdown_spell1.start()
			spell1_launch()
		
		if (HUD == null):
			HUD = ServiceScenes.getMainScene().get_node('stats_heros')
		else:
			HUD.bindTo(coltdown_spell1, 1)

func spell1_launch():
	var direction = (get_global_mouse_position() - champion.position).normalized()
	self.position = champion.position + ServiceSpell.set_in_front_mouse(champion, 
		get_global_mouse_position(), 30)
	self.rotation = (self.position - champion.position).angle()

	self.show()
	
	for i in range(25):
		self.position += (direction * speed)
		await get_tree().create_timer(0).timeout
		
	self.hide()
