extends CharacterBody2D

class_name IEntity

var func_hitted: Array[Callable] = []
var func_hit: Array[Callable] = []

var service_time = ServiceTime.new()
var resource_awaiter = ResourceAwaiter.new()

var class_hero = preload("res://Game/Classes/Hero/Hero.gd").new()

var last_ennemy_hitting
var last_spell_hitting

var multip_sync: MultiplayerSynchronizer
var multip_sync_path: NodePath = "./../MultiplayerSynchronizer"

var spells_placeholder

var animation: AnimatedSprite2D

func _ready():
	animation = self.get_children().filter(func(c): return c is AnimatedSprite2D)[0]
	ServiceScenes.entites.append(self)
	spells_placeholder = spells_placeholder_f()
	
	# ----------------- RESSOURCE LOADER : ALL SPELLS (INCLUDE DUPLICATED) ----------------- #
	if spells_placeholder != null:
		await resource_awaiter.await_resource_loaded(func(): return spells_placeholder.spells_dependencies_ready)
	# ----------------- RESSOURCE LOADER : ALL SPELLS (INCLUDE DUPLICATED) ----------------- #
		
	await get_tree().create_timer(0.5).timeout
	Servrpc.any(self, 'set_multiplayer_properties', [])

func hitted(spell):
	last_spell_hitting = spell
	last_ennemy_hitting = spell.champion
	
	for fc in func_hitted:
		fc.call()

func hit(): #FAIRE LES DEGATS
	for fc in func_hit:
		var node = fc.get_object()
		fc.call()

func set_multiplayer_properties():
	if animation == null:
		animation = self.get_children().filter(func(c): return c is AnimatedSprite2D)[0]
	multip_sync = self.get_parent().get_node("MultiplayerSynchronizer")
	
	var anim_path = self.name + "/" + animation.name
	
	multip_sync.replication_config.add_property(self.name + ":visible")
	multip_sync.replication_config.add_property(self.name + ":modulate")
	multip_sync.replication_config.add_property(self.name + ":rotation")
	multip_sync.replication_config.add_property(self.name + ":position")
	multip_sync.replication_config.add_property(self.name + ":scale")
	
	multip_sync.replication_config.add_property(anim_path + ":animation")
	multip_sync.replication_config.add_property(anim_path + ":modulate")
	multip_sync.replication_config.add_property(anim_path + ":frame")

func spells_placeholder_f(node: Node = self):
	return null

func new_round():
	pass

func _exit_tree():
	Servrpc.recently_freed_nodepaths.append(self.get_path())
