extends IDamagingSpell

var distance_base: float = 30.0  # Distance from center_object
var rotation_speed: float = 40  
var current_angle: float = 0.0
var direction

var angle = 0

func _ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 3.0
		damage_ratio = 0.075
		# ------------------------------------ #
		
		await super._ready()
		animation = $anim_strike

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_multiplayer_authority() && self.visible:
		current_angle += rotation_speed * delta
		direction = Vector2(cos(current_angle), sin(current_angle)).rotated(deg_to_rad(angle))
		self.position = ServiceScenes.championNode.position + (direction * distance_base)
		self.modulate.a = distance_base / 60

func active():
	self.show()
	
	for i in range(10):
		distance_base += 3
		await get_tree().create_timer(0).timeout
		
	await get_tree().create_timer(0.1).timeout
	
	for i in range(10):
		distance_base -= 3
		await get_tree().create_timer(0).timeout
		
	self.hide()

func post_dp_script(id, dp_number):
	angle = (id - 1) * 180
