extends IDamagingSpell

var speed = 20.0
var throw_direction = Vector2.RIGHT
var cd_spell = 8.0
var animation: AnimatedSprite2D
var coltdown_spell: Timer
var HUD

func _ready():	
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 8.0
		damage_ratio = 0.15
		# ------------------------------------ #
		
		await super._ready()
		self.hide()
		
		animation = $Spells_warrior_anim_2
		coltdown_spell = service_time.init_timer(self, cd_spell)
		
		animation.animation_finished.connect(func(): 
			self.hide()
			champion.state_movement = State.StateMovement.NULL
		)

func _process(_delta):
	if is_multiplayer_authority():
		if (HUD == null):
			HUD = ServiceScenes.getMainScene().get_node('stats_heros')
		else:
			HUD.bindTo(coltdown_spell, 2)

func active():
	champion.state_movement = State.StateMovement.IMMOBILE
	self.position = champion.position
	
	self.show()
	animation.play()
	self.position = champion.position + ServiceSpell.set_in_front(champion, 10)


