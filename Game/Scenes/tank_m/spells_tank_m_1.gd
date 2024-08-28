extends IDamagingSpell

var speed = 8.0

func _ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 6.0
		damage_ratio = 0.10
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

	self.show()
	
	for i in range(25):
		self.position += (direction * speed)
		await get_tree().create_timer(0).timeout
		
	self.hide()
