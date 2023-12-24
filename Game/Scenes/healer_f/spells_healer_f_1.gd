extends "res://Game/Interface/IDamagingSpell.gd"

var speed = 20.0
var champion
var cd_spell1 = 5.0
var animation: AnimatedSprite2D
var coltdown_spell1: Timer
var HUD

func _ready():
	if is_multiplayer_authority():
		super._ready()
		self.func_on_entity_entered.append(Callable(get_parent().get_node('animations').get_node('mark_stun'), 'marked'))

		champion = ServiceScenes.championNode
		animation = $spells_healer_f_1_anim
		coltdown_spell1 = service_time.init_timer(self, cd_spell1)
		
		duplicate_spell('spells_healer_f_1_2')

func _process(_delta):
	if is_multiplayer_authority():
		if Input.is_key_pressed(KEY_A) && coltdown_spell1.time_left == 0:
			coltdown_spell1.start()
			spell1_poke()
			
		if (HUD == null):
			HUD = ServiceScenes.getMainScene().get_node('stats_heros')
		else:
			HUD.bindTo(coltdown_spell1, 1)

func spell1_poke():
	if is_multiplayer_authority():
		spell1_movement(self, 30.0)
		await get_tree().create_timer(0.2).timeout
		spell1_movement(get_parent().get_node('spells_healer_f_1_2'), -30.0)

func spell1_movement(obj, deg_arc):
	obj.position = champion.position + ServiceSpell.set_in_front_mouse_incl(champion, 
		get_global_mouse_position(), 30, deg_arc * 1.5)
	obj.modulate.a = 1
	obj.scale = Vector2(0.1, 0.1)
	
	var direction = (get_global_mouse_position() - obj.position).rotated(deg_to_rad(deg_arc))
	var destination = ServiceSpell.distance_range_max(champion.position, get_global_mouse_position(), 400)
	var steps_to_destination = int(ceil(obj.position.distance_to(destination) / speed))
	
	obj.show()
	animation.play("projectile")
	
	for i in range(steps_to_destination):
		direction = direction.rotated(deg_to_rad(deg_arc / steps_to_destination * -2))
		obj.rotation = direction.angle()
		obj.position += (direction.normalized() * speed)
		await get_tree().create_timer(0).timeout
		
	animation.play("aoe")
	for i in range(10):
		obj.scale *= 1.12
		obj.modulate.a -= 0.1
		await get_tree().create_timer(0).timeout
	
	obj.hide()
	
func duplicate_spell(name):
	var MULTIPSYNC = get_parent().get_node('MultiplayerSynchronizer')
	var scnd_shoot = self.duplicate()
	
	scnd_shoot.modulate = Color.WHITE
	scnd_shoot.set_name(name)
	scnd_shoot.set_script(preload("res://Game/Scenes/healer_f/spells_healer_f_1_dp.gd"))
	
	get_parent().add_child.call_deferred(scnd_shoot)
		
	MULTIPSYNC.replication_config.add_property(name + ":position")
	MULTIPSYNC.replication_config.add_property(name + ":rotation")
	MULTIPSYNC.replication_config.add_property(name + ":visible")
	MULTIPSYNC.replication_config.add_property(name + ":modulate")
	MULTIPSYNC.replication_config.add_property(name + ":scale")
	
	ServiceScenes.addSpellToChampion(champion, scnd_shoot)



