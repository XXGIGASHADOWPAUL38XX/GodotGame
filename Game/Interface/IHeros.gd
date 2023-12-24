extends "res://Game/Interface/ICharacter.gd"

func _ready():
	super._ready()
	if ServiceScenes.get_property_from_player(self, 'is_ally') == true:
		self.health_bar.modulate = Color.YELLOW
	elif !is_multiplayer_authority():
		self.health_bar.modulate = Color.RED
	
func take_damage():
	var sp = collision_script.get_spell(last_spell_hitting.name)
	if sp.damage > 0:
		if last_spell_hitting.name.begins_with('spell'):
			self.health_bar.value -= sp.damage + (sp.damage_ratio * last_ennemy_hitting.damage_final) * (
			1 - (armor_final / 100))
		else:
			self.health_bar.value -= sp.damage * (1 - (armor_final / 100))
		ServiceAnimations.set_animation(self, 'animation_hitted')
	else:
		self.health_bar.value -= sp.damage
		ServiceAnimations.set_animation(self, 'animation_healed')
		
	var color = Color.GREEN if sp.damage < 0 else Color.RED
	self.state_movement = state_movement
	health_bar.value -= sp.damage
	
	for i in range(2):
		self.animation.modulate = color
		await get_tree().create_timer(0.15).timeout
		self.animation.modulate = Color.WHITE
		await get_tree().create_timer(0.15).timeout

	self.state_movement = State.StateMovement.NULL
