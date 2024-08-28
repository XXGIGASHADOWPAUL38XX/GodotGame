extends IDamagingCollision

class_name IDamagingSpell

# Called when the node enters the scene tree for the first time.
func after_ready():
	await super.after_ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func send_spell():
	if champion != null:
		champion.hit()
		
	super.send_spell()
	
func output_damage_f(champion_hitted):
	return damage_base + (damage_ratio * champion.damage_final) * (1 - (champion_hitted.armor_final / 100))
