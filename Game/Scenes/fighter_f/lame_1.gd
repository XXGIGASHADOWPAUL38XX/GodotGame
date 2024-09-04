extends IDamagingSpell

var speed = 20.0

var deg_arc = 25

func _ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 8.0
		damage_ratio = 0.2
		# ------------------------------------ #
		
		await super._ready()
		animation = $anim_lame_1

func _process(_delta):
	if is_multiplayer_authority():
		pass

func active(base_destination):
	# INITIAL THROW
	var base_position = champion.position + ServiceSpell.set_in_front_mouse_incl(champion, 
		get_global_mouse_position(), 15, deg_arc)
	self.position = base_position
	
	var base_direction: Vector2 = (base_destination - base_position)
	var distance_to_dstn_base = self.position.distance_to(base_destination)
	var steps = ceil(self.position.distance_to(base_destination) / speed)
	
	self.show()
	animation.play()
	
	for i in range(steps):
		var perpendicular_point = base_position + (base_direction * ((self.position - base_position).dot(base_direction) / base_direction.length_squared()))
		var current_distance_to_dstn = perpendicular_point.distance_to(base_destination)
		var cross_calcul_rotation = deg_arc - (2 * deg_arc * (current_distance_to_dstn / distance_to_dstn_base))
		
		var direction = base_direction.rotated(deg_to_rad(cross_calcul_rotation))
		self.rotation = direction.angle()
		self.position += direction.normalized() * speed
		await get_tree().create_timer(0).timeout
		
	# SPIN
	for i in range(20):
		self.rotate(deg_to_rad(36))
		await get_tree().create_timer(0).timeout
		
		
	# THROW BACK
	base_destination = champion.position
	base_position = self.position
	base_direction = (base_destination - base_position) #AB
	distance_to_dstn_base = base_position.distance_to(base_destination)
	var distance_to_dstn_cmpr = distance_to_dstn_base
	
	while (!ServiceSpell.is_close_to(self, champion, speed)):
		var direction = (champion.position - self.position) #AC
		var distance_to_dstn = self.position.distance_to(champion.position)
		
		var bonus_ratio_distance = distance_to_dstn / distance_to_dstn_cmpr
		var bonus_angle = base_direction.angle_to(direction)
		
		var perpendicular_point = base_position + (direction * ((self.position - base_position).dot(direction) / direction.length_squared()))
		var current_distance_to_dstn = perpendicular_point.distance_to(champion.position)
		var cross_calcul_rotation = - deg_arc + (2 * deg_arc * (current_distance_to_dstn / distance_to_dstn_base))
		
		var final_direction = direction.rotated(deg_to_rad(cross_calcul_rotation + bonus_angle))
		self.rotation = direction.angle()
		self.position += final_direction.normalized() * speed * bonus_ratio_distance
		distance_to_dstn_cmpr = abs(distance_to_dstn_cmpr - (speed * bonus_ratio_distance))
		await get_tree().create_timer(0).timeout
	
	self.hide()
