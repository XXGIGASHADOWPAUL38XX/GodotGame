extends "res://Game/Interface/IDamagingSpell.gd"

func _ready():
	if is_multiplayer_authority():
		super._ready()
		self.hide()

func spell3_explode(target_position):
	if is_multiplayer_authority():	
		self.position = target_position + ServiceSpell.set_random_pos(15)
		self.scale = Vector2(0.02, 0.02)
		self.modulate.a = 1
		self.show()
		
		for i in range(8):
			self.scale = self.scale * 1.03
			self.modulate.a -= 0.01
			await get_tree().create_timer(0).timeout
			
		self.hide()

