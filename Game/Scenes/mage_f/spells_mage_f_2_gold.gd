extends IDamagingSpell

var speed = 20.0

const orb_kind = MageOrb.OrbKind.GOLD

func after_ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 6.0
		damage_ratio = 0.2
		
		state_action = State.StateAction.STUNNED
		state_duration = 0.75
		# ------------------------------------ #
		
		await super.after_ready()
		
			
		frame_based_anim()

func _process(_delta):
	if is_multiplayer_authority() && orb_kind == champion.orb_kind:
		pass
		
func active():
	self.position = champion.orb.position
	self.show()
	animation.play()

	await get_tree().create_timer(1).timeout
		
	animation.stop()
	self.hide()

func frame_based_anim():
	var avg_frame = (animation.sprite_frames.get_frame_count(animation.animation) - 1) * 0.5
	var threshold = avg_frame * 0.5
	animation.frame_changed.connect(func():
		var ratio = max(0, abs(avg_frame - animation.frame) - threshold)
		self.modulate.a = 1 / (1 + (ratio))
	)
	
