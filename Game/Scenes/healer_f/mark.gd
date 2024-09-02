extends IActive

const OFFSET_Y = 60


var mark_overall_node

var cd_target = 10.0
var target_timer: Timer = Timer.new()

var modulate_bool: bool = false
var key_ennemy_marked

func _ready():
	if is_multiplayer_authority():
		self.hide()
		mark_overall_node = get_parent()
		
		await super._ready()
		
		for damaging_spells in spells_placeholder.all_actives.filter(
			func(s): return s is ICollision && s != mark_overall_node.sphere_regen):
				damaging_spells.func_on_entity_entered.append(Callable(self, 'marked').bind(damaging_spells)
		)
		
		animation.frame_changed.connect(func():
			if animation.frame == animation.sprite_frames.get_frame_count(animation.animation) - 1:
				fully_completed_mark()
		)
		

func _process(delta):
	if is_multiplayer_authority():
		if self.visible && key_ennemy_marked != null:
			self.position = Vector2(key_ennemy_marked.position.x, key_ennemy_marked.position.y - OFFSET_Y)
		
		if target_timer.time_left == 0:
			self.hide()
		elif target_timer.time_left < 2.5:
			modulate_bool = await ServiceSpell.modulate_obj(self, modulate_bool)
		else:
			self.show()

func marked(spell):
	if spell.player_hitted == key_ennemy_marked:
		Servrpc.send_to_multi_auth(self, 'send_to_local', [spell.player_hitted])

func send_to_local(player_hitted):
	animation.frame += 1
	target_timer = service_time.init_timer(self, cd_target)
	target_timer.start()

func fully_completed_mark():
	animation.frame = 0
	mark_overall_node.sphere_regen.active()
	Servrpc.send_to_multi_auth(key_ennemy_marked, 'stun', [key_ennemy_marked])
	
func stun(key_ennemy_marked):
	key_ennemy_marked.add_state(self, 'states_action', State.StateAction.CONCENTRATE, 0.75)

