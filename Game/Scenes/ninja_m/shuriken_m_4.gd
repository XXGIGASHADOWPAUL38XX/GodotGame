extends IDamagingSpell

var throw_direction = Vector2.RIGHT

var is_dp_shuriken = true

var angle # INSTANCIATED BY PARENT

func _ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 10.0
		damage_ratio = 0.25
		# ------------------------------------ #
		
		await super._ready()

func _process(delta):
	if is_multiplayer_authority():
		pass

func active():
	var speed = 15.0
	var main_vector = get_global_mouse_position() - champion.position
	
	self.position = champion.position + (main_vector.normalized() * 30).rotated(deg_to_rad(angle))
	self.rotation = main_vector.angle()

	self.show()
	for i in range(6):
		self.position += main_vector.normalized().rotated(deg_to_rad(angle)) * speed
		await get_tree().create_timer(0).timeout

	self.hide()

