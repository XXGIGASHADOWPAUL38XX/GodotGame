extends IDamagingSpell

var speed = 20.0
var throw_direction = Vector2.RIGHT
var cd_spell4 = 1.5
var spell4: AnimatedSprite2D
var coltdown_spell4: Timer
var HUD
var animation

func _ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 8.0
		damage_ratio = 0.25
		# ------------------------------------ #
		
		self.hide()

		champion = ServiceScenes.championNode
		coltdown_spell4 = service_time.init_timer(self, cd_spell4)
		animation = $Spells_ranger_anim_4
		
		await super._ready()

func _process(_delta):
	if is_multiplayer_authority():
		if (HUD == null):
			HUD = ServiceScenes.getMainScene().get_node('stats_heros')
		else:
			HUD.bindTo(coltdown_spell4, 4)
	
func active():
	self.show()
	animation.play("spell_4_pre_anim")
	
	await animation.animation_finished
	self.hide()
	
