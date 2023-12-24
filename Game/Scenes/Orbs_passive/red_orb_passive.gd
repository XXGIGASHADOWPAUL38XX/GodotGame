extends AnimatedSprite2D

var augment: int = 0
const MAX_AUGMENT = 3
var service_time = preload("res://Game/Services/service_time.gd").new()

var coltdown_stay = Timer.new()
var cd_stay = 3.0

var coltdown_explode = Timer.new()
var cd_explode = 8.0

var ennemy_marked

var modulate_bool: bool = false

func _ready():
	if is_multiplayer_authority():
		coltdown_stay = service_time.init_timer(self, cd_stay)
		coltdown_explode = service_time.init_timer(self, cd_explode)
		coltdown_stay.timeout.connect(
			func(): 
				augment = 0
				self.hide()
		)
		
		ServiceScenes.championNode.add_func_hit(Callable(special))

func _process(delta):
	if is_multiplayer_authority():
		if ennemy_marked != null:
			self.position = ennemy_marked.position
	
		if self.visible:
			modulate_bool = await ServiceSpell.modulate_obj(self, modulate_bool)

func special(ennemy):
	if is_multiplayer_authority() && coltdown_explode.time_left == 0:
		ennemy_marked = ennemy
		self.show()
		coltdown_stay.start()
		
		if augment < MAX_AUGMENT:
			augment += 1
			self.frame = augment
			coltdown_stay.start()
		else:
			Servrpc.send_to_id('id_ennemy', self, 'explode', [])
			coltdown_explode.start()

func explode():
	pass
#	ServiceScenes.championNode.take_damage(5, State.StateMovement.NULL)
