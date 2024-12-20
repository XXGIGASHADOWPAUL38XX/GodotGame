extends ICollision

var dp_anim_display_entity

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		CONF_DETECT_WITH = [
			ServiceScenes.entities.ennemiesNode,
			ServiceScenes.entities.entitiesNode,
		] 
		
		func_on_entity_entered.append(Callable(self, 'display_entity'))
		
	await super._ready()
	
	if is_multiplayer_authority():
		dp_anim_display_entity = spells_placeholder.dp_anim_display_entity

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func active():
	animation.play()
	self.scale = Vector2(0.08, 0.08)
	self.modulate.a = 1
	self.show()
	
	for i in range(140):
		self.scale += Vector2(0.02, 0.02)
		await get_tree().create_timer(0.016).timeout
		self.modulate.a -= 0.007
		
	animation.stop()
	
func display_entity():
	dp_anim_display_entity.get_available_de_anim(player_hitted)
