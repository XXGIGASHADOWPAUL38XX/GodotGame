extends IDamagingCollision

var collision_shape

var augment: int = 0
const MAX_AUGMENT = 3

var coltdown_stay = Timer.new()
var cd_stay = 3.0
var coltdown_explode = Timer.new()
var cd_explode = 8.0

var modulate_bool: bool = false

var duplicator
var key_ennemy_marked

func _ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 4.0
		damage_ratio = 0.1
		# ------------------------------------ #
		
		collision_shape = $CollisionShape2D
		
		COLLISION_ON_SPECIFIC_ANIM = true
		animation.animation_changed.connect(func():
			collision_shape.disabled = animation.animation == "explode"
		)
		
		duplicator = get_parent()
		
		await super._ready()
		
		coltdown_stay = service_time.init_timer(self, cd_stay)
		coltdown_explode = service_time.init_timer(self, cd_explode)
		coltdown_stay.timeout.connect(func(): 
			augment = 0
			self.hide()
		)
		
		animation.frame_changed.connect(func(): collision_shape.disabled = animation.frame != MAX_AUGMENT)
		ServiceScenes.championNode.func_hitted.append(Callable(self, 'active'))

func _process(delta):
	if is_multiplayer_authority():
		if champion != null:
			self.position = champion.position
	
		if self.visible:
			modulate_bool = await ServiceSpell.modulate_obj(self, modulate_bool)

func active():
	if is_multiplayer_authority() && coltdown_explode.time_left == 0:
		self.show()
		
		if augment < MAX_AUGMENT:
			augment += 1
			animation.frame = augment
			coltdown_stay.start()
		else:
			Servrpc.send_to_id(key_ennemy_marked.get_multiplayer_authority(), self, 'explode', [])
			coltdown_explode.start()

func explode():
	augment = 0
	self.hide()
#	champion.take_damage(5, State.StateAction.NULL)

func post_dp_script(id, nbr_dupl):
	key_ennemy_marked = duplicator.ennemies_sorted()[id - 1]
