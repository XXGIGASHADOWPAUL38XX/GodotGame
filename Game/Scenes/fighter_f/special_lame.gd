extends IDamagingSpell

var animation

var angle = 0
var speed = 16

func _ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 8.0
		damage_ratio = 0.2
		# ------------------------------------ #
		
		await super._ready()
		animation = $anim_special_dash

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_multiplayer_authority():
		pass

func active():
	var main_vector = Vector2.RIGHT.rotated(deg_to_rad(angle))
	self.position = champion.position + ServiceSpell.set_in_front(champion, 30, angle)
	self.rotation = (self.position - champion.position).angle()
	
	self.show()
	
	for i in range(6):
		self.position += main_vector * speed
		await get_tree().create_timer(0).timeout
	
func second_active(desired_lame):
	if self == desired_lame:
		champion.position = self.position
		self.hide()
		return 
	
	while (self.position.distance_to(desired_lame.position) >= speed): 
		self.position += (desired_lame.position - self.position).normalized() * speed
		await get_tree().create_timer(0).timeout

	self.hide()

func post_dp_script(id, dp_number):
	angle = (id - 1) * 90
