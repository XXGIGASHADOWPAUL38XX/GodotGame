extends "res://Game/Interface/IHoldableSpell.gd"

var speed = 20.0
var champion
var pos_offset

var distance: float = 25  # Distance from center_object
var rotation_speed: float = 2  # Adjust as needed
var current_angle: float = 0.0
var direction
var is_launched = false

func _ready():	
	if is_multiplayer_authority():
		pos_offset = Vector2.ZERO
		cd_spell = 3
		spell = $speical_ranger_anim
		coltdown_spell = service_time.init_timer(self, cd_spell)
		timer_key_release_cd = 1.5
		key = KEY_D
		
		super._ready()
		self.func_on_entity_entered.append(Callable(get_parent().get_node('target_ranger_m_3'), 'marked').bind(self))
		
		champion = ServiceScenes.championNode
		for i in range(2, 9):
			duplicate_spell(i)

func _process(delta):
	if is_multiplayer_authority():
		super._process(delta)
			
#		if (HUD == null):
#			HUD = ServiceScenes.getMainScene().get_node('stats_heros')
#		else:
#			HUD.bindTo(coltdown_spell, 3)
			
		if self.visible && !is_launched:
			current_angle += rotation_speed * delta
			direction = Vector2(cos(current_angle), sin(current_angle))
			self.position = ServiceScenes.championNode.position + (direction * distance)

func start_spell():
	champion.set_attribute('state_damage', State.StateMovement.IMMOBILE)
	var specials = get_parent().get_children().filter(func(obj) : return obj.name.begins_with('special_ranger_m'))
	specials.map(func(obj) : obj.show())
	
	spell_movement()
	for special in specials:
		await get_tree().create_timer(0.16).timeout
		special.spell_movement()
		
func stop_spell():
	super.stop_spell()
	champion.set_attribute('state_movement', State.StateMovement.IMMOBILE)
	for special in get_parent().get_children().filter(func(obj) : return obj.name.begins_with('special_ranger_m')):
		special.hide()

func spell_movement():
	is_launched = true
	self.position = champion.position + ServiceSpell.set_in_front_mouse(champion, get_global_mouse_position(), 35)

	var direction = get_global_mouse_position() - self.position
	direction = direction.normalized()

	for i in range(15):
		self.position += (direction * speed)
		await get_tree().create_timer(0.01).timeout
	
	self.hide()
	is_launched = false
	
func duplicate_spell(index):
	var MULTIPSYNC = get_parent().get_node('MultiplayerSynchronizer')
	var scnd_shoot = self.duplicate()
	
	scnd_shoot.set_multiplayer_authority(get_multiplayer_authority())
	scnd_shoot.set_name("special_ranger_m_R" + str(index))
	scnd_shoot.set_script(preload("res://Game/Scenes/ranger_m/speical_ranger_m_dp.gd"))
	scnd_shoot.pos_offset = Vector2(20, 0).rotated(deg_to_rad((index - 1) * 45))
	
	get_parent().add_child.call_deferred(scnd_shoot)
		
	MULTIPSYNC.replication_config.add_property(name + ":position")
	MULTIPSYNC.replication_config.add_property(name + ":visible")
	ServiceScenes.addSpellToChampion(champion, scnd_shoot)
