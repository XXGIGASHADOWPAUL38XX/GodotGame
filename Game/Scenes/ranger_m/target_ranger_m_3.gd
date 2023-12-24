extends Area2D

var speed = 20.0
var champion
var cd_spell3 = 6.0
var cd_target = 10.0
var animation: AnimatedSprite2D
var coltdown_spell3: Timer
var target_timer: Timer = Timer.new()
var service_time = preload("res://Game/Services/service_time.gd").new()
var HUD
var target_damage
var bubbles
var mines_count
var ennemy_marked
var modulate_bool: bool = false

func _ready():
	if is_multiplayer_authority():
		mines_count = get_parent().get_node('animations').get_node('spells_4_count')
		bubbles = get_parent().get_node('animations').get_node('spells_3_bubbles')
		target_damage = get_parent().get_node('spells_ranger_m_3')
		self.hide()

		champion = ServiceScenes.championNode
		coltdown_spell3 = service_time.init_timer(self, cd_spell3)
	
	animation = $Target_ranger_anim_3

func _process(delta):
	if is_multiplayer_authority() && ennemy_marked != null:
		self.position = ennemy_marked.position
		
		if target_timer.time_left == 0:
			mines_count.frame = 0
			self.hide()
		elif target_timer.time_left < 2.5:
			modulate_bool = await ServiceSpell.modulate_obj(self, modulate_bool)
		else:
			self.show()

		if Input.is_key_pressed(KEY_E) && coltdown_spell3.time_left == 0 && animation.frame > 0:
			coltdown_spell3.start()
			spell3_target()
			
		self.rotate(delta)

func spell3_target():
	var thread_1 = Thread.new()
	var thread_2 = Thread.new()
	
	for i in range(animation.frame):
		thread_1.start(Callable(target_damage, 'spell3_explode').bind(self.global_position))
		thread_2.start(Callable(bubbles, 'spell3_bubble').bind(self.global_position))
		animation.frame -= 1
		mines_count.frame += 1
		
		await get_tree().create_timer(0.25).timeout
		
		thread_1.wait_to_finish()
		thread_2.wait_to_finish()
		
func marked(spell):
	Servrpc.send_to_multi_auth(self, 'send_to_local', [spell.player_hitted])

func send_to_local(player_hitted):
	ennemy_marked = player_hitted
	animation.frame += 1
	target_timer = service_time.init_timer(self, cd_target)
	target_timer.start()



