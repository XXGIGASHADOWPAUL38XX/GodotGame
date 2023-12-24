extends "res://Game/Interface/ISpell.gd"

func _ready():
	self.func_on_entity_entered.append(Callable(self, 'collision'))
	super._ready()

func collision():
	if self.visible && ennemies_in.find(player_hitted) != -1:
		send_damage()

func send_damage():
	Servrpc.send_to_id(player_hitted.get_multiplayer_authority(), player_hitted, 'hitted', [self]) # heros hitted BY ennemy spell

	var sp = collision_script.get_spell(self.name)
	spells_retrigger[player_hitted] = service_time.init_timer(self, sp.retrigger)
	spells_retrigger[player_hitted].start()
	spells_retrigger[player_hitted].timeout.connect(collision)
