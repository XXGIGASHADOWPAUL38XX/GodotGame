extends ICollision

var cd_mark = 4.0
var mark_timer: Timer = Timer.new()
var duplicator

var modulate_bool: bool = false
var key_ennemy_marked

func _ready():
	if is_multiplayer_authority():
		duplicator = self.get_parent()
		
		mark_timer = service_time.init_timer(self, cd_mark)
		mark_timer.timeout.connect(Callable(self, 'show_on_timeout'))
			
		await super._ready()

func _process(delta):
	if is_multiplayer_authority() && key_ennemy_marked != null && self.visible:
		self.position = key_ennemy_marked.position
		modulate_bool = ServiceSpell.modulate_obj(self, modulate_bool)
			
		self.rotate(delta)

func send_to_local(player_hitted):
	animation.frame += 1

func show_on_timeout():
	self.show()
	
func show_on_shadow_entered():
	self.show()
	
func hide_on_dash():
	self.hide()
	mark_timer.start()
	
func post_dp_script(id, nbr_dupl):
	key_ennemy_marked = duplicator.marked_entities[id - 1]

