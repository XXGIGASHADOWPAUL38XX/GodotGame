extends IDamagingSpell

var speed = 10.0

func _ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 8.0
		damage_ratio = 0.12
		# ------------------------------------ #
		
		await super._ready()

			
		self.body_entered.connect(func(obj): if obj.visible && obj in spells_placeholder.rocks:
			self.hide()
			spells_placeholder.explode.explode()
		)

func _process(_delta):
	if is_multiplayer_authority():
		pass

func active():
	var direction = (get_global_mouse_position() - champion.position).normalized()
	self.position = champion.position + ServiceSpell.set_in_front_mouse(champion, 
		get_global_mouse_position(), 30)
	self.rotation = (self.position - champion.position).angle()
	champion.set_attribute('speed', 0, 1)

	self.show()
	
	for i in range(40):
		if self.visible:
			self.position += (direction * speed)
			champion.position = self.position + ServiceSpell.set_in_front(self, -20)
			await get_tree().create_timer(0.02).timeout
		
	self.hide()

