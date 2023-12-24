extends "res://Game/Interface/IDamagingSpell.gd"

var speed = 16.0
var champion
var throw_direction = Vector2.RIGHT
var cd_spell1 = 3.0
var cd_spell3 = 7.0
var spell: AnimatedSprite2D
var coltdown_spell1: Timer
var coltdown_spell3: Timer
var passive
var HUD

func _ready():
	if is_multiplayer_authority():
		super._ready()
		champion = ServiceScenes.championNode
		passive = get_parent().get_node('passive_mage_f')
		
		spell = $Spells_mage_anim
		
		coltdown_spell1 = service_time.init_timer(self, cd_spell1)
		coltdown_spell3 = service_time.init_timer(self, cd_spell3)

func _process(delta):
	if is_multiplayer_authority():
		if Input.is_key_pressed(KEY_A) && coltdown_spell1.time_left == 0:
			coltdown_spell1.start()
			spell1_launch()

		if Input.is_key_pressed(KEY_E) && coltdown_spell3.time_left == 0:
			coltdown_spell3.start()
			spell2_shield()
			
		if (HUD == null):
			HUD = ServiceScenes.getMainScene().get_node('stats_heros')
		else:
			HUD.bindTo(coltdown_spell1, 1)
			HUD.bindTo(coltdown_spell3, 3)
			
func spell1_launch():
	passive.set_meta('passive', false)
	spell.play("spell1_launch")
	self.position = champion.position + ServiceSpell.set_in_front_mouse(champion, get_global_mouse_position(), 30)
	
	var direction = get_global_mouse_position() - position
	direction = direction.normalized()

	self.show()
	for i in range(12):
		self.position += direction * speed
		await get_tree().create_timer(0).timeout

	passive.position = self.position
	spell.stop()

func spell2_shield():
	spell.play("spell2_shield")
	self.show()

	while (ServiceSpell.isCloseTo(self, champion, 20) == false):
		var direction = champion.position - self.position
		direction = direction.normalized()
		
		self.position += direction * speed
		await get_tree().create_timer(0).timeout
		
	self.hide()
		
	passive.set_meta('passive', true)


