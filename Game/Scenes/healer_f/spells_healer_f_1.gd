extends IDamagingSpell

var speed = 20.0
var animation: AnimatedSprite2D
var deg_arc = 30

func _ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 6.0
		damage_ratio = 0.15
		# ------------------------------------ #
		
		await super._ready()
		
		print(spell_controller.mark_stun_anim)
		self.func_on_entity_entered.append(Callable(spell_controller.mark_stun_anim, 'marked'))

		animation = $anim_healer_f_1

func _process(_delta):
	if is_multiplayer_authority():
		pass

func active():
	self.position = champion.position + ServiceSpell.set_in_front_mouse_incl(champion, 
		get_global_mouse_position(), 30, deg_arc * 1.5)
	self.modulate.a = 1
	
	var direction = (get_global_mouse_position() - self.position).rotated(deg_to_rad(deg_arc))
	var destination = ServiceSpell.distance_range_max(champion.position, get_global_mouse_position(), 400)
	var steps_to_destination = int(ceil(self.position.distance_to(destination) / speed))
	
	self.scale = Vector2(0.1, 0.1)
	self.show()
	animation.play("projectile")
	
	for i in range(steps_to_destination):
		direction = direction.rotated(deg_to_rad(deg_arc / steps_to_destination * -2))
		self.rotation = direction.angle()
		self.position += (direction.normalized() * speed)
		await get_tree().create_timer(0).timeout
		
	animation.play("aoe")
	for i in range(10):
		self.scale *= 1.12
		self.modulate.a -= 0.1
		await get_tree().create_timer(0).timeout
	
	self.hide()
