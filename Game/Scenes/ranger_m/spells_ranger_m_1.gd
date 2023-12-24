extends "res://Game/Interface/IDamagingSpell.gd"

var speed = 20.0
var champion
var throw_direction = Vector2.RIGHT
var cd_spell1 = 4.0
var spell1: AnimatedSprite2D
var coltdown_spell1: Timer
var HUD

func _ready():	
	if is_multiplayer_authority():
		super._ready()
		self.func_on_entity_entered.append(Callable(get_parent().get_node('target_ranger_m_3'), 'marked').bind(self))

		spell1 = $Spells_ranger_anim_1
		coltdown_spell1 = service_time.init_timer(self, cd_spell1)
		
	champion = ServiceScenes.championNode
	duplicate_spell('spells_ranger_m_1_2')
	duplicate_spell('spells_ranger_m_1_3')

func _process(_delta):
	if is_multiplayer_authority():
		if Input.is_key_pressed(KEY_A) && coltdown_spell1.time_left == 0:
			coltdown_spell1.start()
			spell1_range()
			
		if (HUD == null):
			HUD = ServiceScenes.getMainScene().get_node('stats_heros')
		else:
			HUD.bindTo(coltdown_spell1, 1)

func spell1_range():
	if is_multiplayer_authority():
		spell1_movement(self)
		await get_tree().create_timer(0.2).timeout
		spell1_movement(get_parent().get_node('spells_ranger_m_1_2'))

func spell1_movement(obj):
	obj.position = champion.position + ServiceSpell.set_in_front_mouse(champion, get_global_mouse_position(), 35)
	obj.position.y += randf_range(-40, 40)
	obj.rotation = ServiceSpell.set_in_front_mouse(champion, get_global_mouse_position(), 35).angle()
	obj.show()

	var direction = get_global_mouse_position() - obj.position
	direction = direction.normalized()

	for i in range(11):
		obj.position += (direction * speed)
		await get_tree().create_timer(0).timeout
		
	obj.hide()
	
func duplicate_spell(name):
	var MULTIPSYNC = get_parent().get_node('MultiplayerSynchronizer')
	var scnd_shoot = self.duplicate()
	
	scnd_shoot.set_multiplayer_authority(get_multiplayer_authority())
	scnd_shoot.set_name(name)
	scnd_shoot.set_script(preload("res://Game/Scenes/ranger_m/spells_ranger_m_1_2.gd"))
	
	get_parent().add_child.call_deferred(scnd_shoot)
		
	MULTIPSYNC.replication_config.add_property(name + ":position")
	
	MULTIPSYNC.replication_config.add_property(name + ":visible")
	
	ServiceScenes.addSpellToChampion(champion, scnd_shoot)



