extends "res://Game/Interface/IDamagingSpell.gd"

var speed = 20.0
var champion
var cd = 8.0
var spell1: AnimatedSprite2D
var target_position = Vector2.ZERO
var coltdown = Timer
var HUD
var coltdown_spell4
var cd_spell4 = 2.0
var passive

func _ready():	
	if is_multiplayer_authority():
		super._ready()
		self.hide()
		champion = ServiceScenes.championNode
		passive = get_parent().get_node('passive_mage_f')
		
		spell1 = $Spells_mage_ult
		coltdown_spell4 = service_time.init_timer(self, cd_spell4)

func _process(_delta):
	if is_multiplayer_authority():
		if Input.is_key_pressed(KEY_SPACE) && coltdown_spell4.time_left == 0 && passive.get_meta('passive') == true:
			coltdown_spell4.start()
			spell_launch()
			
		if (HUD == null):
			HUD = ServiceScenes.getMainScene().get_node('stats_heros')
		else:
			HUD.bindTo(coltdown_spell4, 4)

func spell_launch():
	passive.get_node('AnimatedSprite2D').play('ult')
	spell1.play("spell1")
	
	for i in range (4):
		self.position = champion.position + ServiceSpell.set_in_front_mouse(champion, get_global_mouse_position(), 25)
		var direction = get_global_mouse_position() - position
		direction = direction.normalized()
		self.show()
			
		for j in range(10):
			self.position += direction * speed
			await get_tree().create_timer(0).timeout
			
		self.hide()
		
	spell1.stop()
	passive.get_node('AnimatedSprite2D').play('passive')
