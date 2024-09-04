extends Area2D

#extends "res://Game/Interface/IReceiverObject.gd"
#
#const NUMBER_FRAMES = 4
#const MARGIN_SPAWN_X = 600
#const MARGIN_SPAWN_Y = 400
#
#var timer_spawn
#var animation
#
#var modulate_bool: bool = false
#
## Called when the node enters the scene tree for the first time.
#func _ready():
#	await super._ready()
#	animation = $orb_gem_anim
#	if is_multiplayer_authority():
#		timer_spawn = service_time.init_timer(self, randf_range(5, 15))
#		timer_spawn.start()
#		timer_spawn.timeout.connect(spawn)
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	if animation.frame + 1 < NUMBER_FRAMES:
#		modulate_bool = ServiceSpell.modulate_obj(self, modulate_bool)
#
#func spawn():
#	ServiceAnnounce.set_announce(
#		'An orb fragment has appeared',
#		'res://Game/Ressources/Background/Gems/orb_gem_icon.png',
#		'res://Game/Ressources/Background/Gems/orb_gem_icon.png'
#	)
#
#	animation.animation = 'default'
#	self.modulate.a = 1
#	self.position = Vector2(
#		randf_range(MARGIN_SPAWN_X, ServiceWindow.scene_size.x - MARGIN_SPAWN_X), 
#		randf_range(MARGIN_SPAWN_Y, ServiceWindow.scene_size.y - MARGIN_SPAWN_Y))
#	self.show()
#
#func take_damage():
#	if (animation.frame + 1 < NUMBER_FRAMES):
#		animation.frame += 1
#	else:
#		die_animation(last_ennemy_hitting)
#		orb_upgrade()
#
#func die_animation(champion):
#	for i in range(10):
#		self.modulate.a -= 0.1
#		await get_tree().create_timer(0.4).timeout
#
#	self.hide()
#
#	timer_spawn.start()
#
#func orb_upgrade():
#	Servrpc.send_to_id(
#		last_ennemy_hitting.get_multiplayer_authority(), 
#		ServiceScenes.getMainScene().get_node('items'), 
#		'orb_upgraded', []
#	)
