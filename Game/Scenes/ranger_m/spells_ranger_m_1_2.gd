extends IDamagingSpell

func after_ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 9.0
		damage_ratio = 0.25
		# ------------------------------------ #
		
		await super.after_ready()


