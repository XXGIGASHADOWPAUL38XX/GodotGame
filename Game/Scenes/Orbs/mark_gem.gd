extends IDamagingCollision

var animation
var collision_shape

var augment: int = 0
const MAX_AUGMENT = 3

var coltdown_stay = Timer.new()
var cd_stay = 3.0
var coltdown_explode = Timer.new()
var cd_explode = 8.0

var modulate_bool: bool = false

func _ready():
	if is_multiplayer_authority():
		animation = $red_orb_passive
		collision_shape = $CollisionShape2D
		await super._ready()
		
		coltdown_stay = service_time.init_timer(self, cd_stay)
		coltdown_explode = service_time.init_timer(self, cd_explode)
		coltdown_stay.timeout.connect(
			func(): 
				augment = 0
				self.hide()
		)
		
		animation.frame_changed.connect(func(): collision_shape.disabled = animation.frame != MAX_AUGMENT)
		champion.func_hitted.append(Callable(self, "special"))

func _process(delta):
	if is_multiplayer_authority():
		if champion != null:
			self.position = champion.position
	
		if self.visible:
			modulate_bool = await ServiceSpell.modulate_obj(self, modulate_bool)

func special():
	if is_multiplayer_authority() && coltdown_explode.time_left == 0:
		self.show()
		coltdown_stay.start()
		
		if augment < MAX_AUGMENT:
			augment += 1
			animation.frame = augment
			coltdown_stay.start()
		else:
			Servrpc.send_to_id('id_ennemy', self, 'explode', [])
			coltdown_explode.start()

func explode():
	pass
#	champion.take_damage(5, State.StateMovement.NULL)
