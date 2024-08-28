extends IDamagingSpell

var speed = 20.0
var throw_direction = Vector2.RIGHT
var delay

func after_ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 5.0
		damage_ratio = 0.15
		# ------------------------------------ #
		
		await super.after_ready()
		self.hide()
		
		champion = ServiceScenes.championNode
		animation = $throw_ranger_anim

func active(main_mector):
	await get_tree().create_timer(delay).timeout
	self.position = champion.position + (main_mector.normalized() * 35)
	self.position.y += randf_range(-30, 30)
	self.rotation = main_mector.angle()
	self.show()

	for i in range(11):
		self.position += (main_mector.normalized() * speed)
		await get_tree().create_timer(0).timeout
		
	self.hide()

func post_dp_script(id, nbr_dupl):
	delay = [0, 0.2, 0.4, 0.6, 0.8][id - 1]
