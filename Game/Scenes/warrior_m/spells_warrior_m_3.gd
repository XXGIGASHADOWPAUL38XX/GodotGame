extends IDamagingSpell

var speed = 20.0
var throw_direction = Vector2.RIGHT
var cd_spell3 = 3.0
var spell3: AnimatedSprite2D
var coltdown_spell3: Timer
var HUD

func _ready():	
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 3.0
		damage_ratio = 0.075
		# ------------------------------------ #
		
		await super._ready()
		self.hide()
		champion = ServiceScenes.championNode
		
		spell3 = $Spells_warrior_anim_3
		coltdown_spell3 = service_time.init_timer(self, cd_spell3)

func _process(_delta):
	if is_multiplayer_authority():
		if Input.is_key_pressed(KEY_E) && coltdown_spell3.time_left == 0:
			coltdown_spell3.start()
			active()
			
		if (HUD == null):
			HUD = ServiceScenes.getMainScene().get_node('stats_heros')
		else:
			HUD.bindTo(coltdown_spell3, 3)

func active():
	self.position = champion.position + ServiceSpell.set_in_front_mouse(champion, get_global_mouse_position(), 30)
	throw_direction = (get_global_mouse_position() - champion.position).normalized()
	
	champion.state_movement = State.StateMovement.IMMOBILE
	champion.state_damage = State.StateDamage.IMMUNE
	champion.hide()
	self.show()
	
	self.rotation = (get_global_mouse_position() - self.position).angle()
	spell3.play("spell3_attack")

	for i in range(30):
		self.position += throw_direction * 3
		await get_tree().create_timer(0).timeout
	
	spell3.stop()
	champion.position = self.position + ServiceSpell.set_in_front(self, 15)
	self.hide()
	champion.show()
	
	champion.state_movement = State.StateMovement.NULL
	champion.state_damage = State.StateDamage.NULL
