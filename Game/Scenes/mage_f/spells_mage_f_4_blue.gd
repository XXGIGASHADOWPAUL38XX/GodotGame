extends IDamagingSpell

var speed = 20.0
var cd = 8.0
var spell1: AnimatedSprite2D
var target_position = Vector2.ZERO
var coltdown = Timer
var HUD
var coltdown_spell4
var cd_spell4 = 2.0

const orb_kind = MageOrb.OrbKind.BLUE

func after_ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 7.0
		damage_ratio = 0.2
		# ------------------------------------ #
		
		await super.after_ready()
		self.hide()
		
		spell1 = $Spells_mage_ult
		coltdown_spell4 = service_time.init_timer(self, cd_spell4)

func _process(_delta):
	if is_multiplayer_authority():
		if Input.is_key_pressed(KEY_SPACE) && coltdown_spell4.time_left == 0:
			coltdown_spell4.start()
			spell_launch()
			
		if (HUD == null):
			HUD = ServiceScenes.getMainScene().get_node('stats_heros')
		else:
			HUD.bindTo(coltdown_spell4, 4)

func spell_launch():
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
