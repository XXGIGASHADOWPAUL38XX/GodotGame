extends ICollision

var animation 
var zone_damage
var counter_count

func _ready():
	if is_multiplayer_authority():
		self.modulate.a = 0.5
		animation = $anim_reduce
		
		await super._ready()
		zone_damage = spell_controller.zone_damage
		counter_count = spell_controller.counter_count
		
		self.visibility_changed.connect(func():
			if self.visible:
				champion.func_hitted.append(Callable(self, 'hitted_on_active'))
			else:
				champion.func_hitted.remove_at(champion.func_hitted.find(Callable(self, 'hitted_on_active')))
		)

func _process(delta):
	if is_multiplayer_authority():
		if self.visible:
			self.position = champion.position
			
func active():
	pass

func hitted_on_active():
	counter_count.increment()

