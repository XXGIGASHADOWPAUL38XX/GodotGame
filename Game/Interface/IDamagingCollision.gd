extends ICollision

class_name IDamagingCollision

# pas obligé de les utiliser mais utilisé de base
# si on ne veut pas utilser on surcharge output_damage_f()
@export var damage_base: float
@export var damage_ratio: float
@export var state: State.StateAction = State.StateAction.NULL

var output_damage = Callable(output_damage_f)

func after_ready():
	await super.after_ready()
	self.func_on_entity_entered.append(Callable(self, 'collision'))

func collision():
	if self.visible && ennemies_in.find(player_hitted) != -1:
		send_spell()

func send_spell():
	Servrpc.send_to_id(player_hitted.get_multiplayer_authority(), player_hitted, 'hitted', [self]) # heros hitted BY ennemy spell

	if retrigger:
		retrigger_timer = service_time.init_timer(self, retrigger_time)
		retrigger_timer.start()
		retrigger_timer.timeout.connect(collision)

# champion -> champion hitting (self champion of spell)
# champion_hitted -> champion hitted, passed while calling the callable in IEntity
func output_damage_f(champion_hitted):
	return damage_base
	
func set_multiplayer_properties():
	super.set_multiplayer_properties()
		
	multip_sync.replication_config.add_property(self.name + ":damage_base")
	multip_sync.replication_config.add_property(self.name + ":damage_ratio")
	multip_sync.replication_config.add_property(self.name + ":state")

