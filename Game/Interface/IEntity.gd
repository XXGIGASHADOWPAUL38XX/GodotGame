extends CharacterBody2D

class_name IEntity

var func_hitted: Array[Callable] = []
var func_hit: Array[Callable] = []

var service_time = preload("res://Game/Services/service_time.gd").new()
var class_hero = preload("res://Game/Classes/Hero/Hero.gd").new()

var last_ennemy_hitting
var last_spell_hitting

var multip_sync: MultiplayerSynchronizer

func _ready():
	# ----------------- RESSOURCE LOADER ----------------- #
	self.process_mode = Node.PROCESS_MODE_DISABLED
	await get_tree().create_timer(1).timeout
#
	self.process_mode = Node.PROCESS_MODE_PAUSABLE
	# ----------------- RESSOURCE LOADER ----------------- #
	
	Servrpc.any(self, 'set_multiplayer_properties', [])

func hitted(spell):
	last_spell_hitting = spell
	last_ennemy_hitting = spell.get_parent().get_parent()
	
	for fc in func_hitted:
		fc.call()

func hit(): #FAIRE LES DEGATS
	for fc in func_hit:
		var node = fc.get_object()
		fc.call()

func set_multiplayer_properties():
	multip_sync = self.get_parent().get_node("MultiplayerSynchronizer")
	
	var animation = self.get_children().filter(func(c): return c is AnimatedSprite2D)[0]
	var anim_path = self.name + "/" + animation.name
	
	multip_sync.replication_config.add_property(self.name + ":visible")
	multip_sync.replication_config.add_property(self.name + ":modulate")
	multip_sync.replication_config.add_property(self.name + ":rotation")
	multip_sync.replication_config.add_property(self.name + ":position")
	
	multip_sync.replication_config.add_property(anim_path + ":animation")
	multip_sync.replication_config.add_property(anim_path + ":modulate")
	multip_sync.replication_config.add_property(anim_path + ":frame")




