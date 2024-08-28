extends Node

class_name IPlaceholderSpells

var all_actives
var duplication_phldrs
var ready_to_load_spell: bool = false
var spells_dependencies_ready: bool = false

func _ready():
	after_ready()

# Called when the node enters the scene tree for the first time.
func after_ready():
	duplication_phldrs = get_duplication_phldrs()
	
	# PERMET D'ATTENDRE QUE LES SORTS SOIENT DUPLIQUEES
	if duplication_phldrs.size() == 0:
		ready_to_load_spell = true
	
	# ----------------- RESSOURCE LOADER : DUPLICATED SPELLS ----------------- #
	await await_resource_loaded(func(): return self.ready_to_load_spell)
	# ----------------- RESSOURCE LOADER : DUPLICATED SPELLS ----------------- #

	all_actives = get_all_actives()
	
	# ON A MTN TOUS LES SORTS / ENTITES : ON VA POUVOIR ARRETER DE FAIRE ATTENDRE LE _ready() d'IActive / IEntity
	spells_dependencies_ready = true

func get_all_actives(parent=self):
	var all_actives = []
	for c in parent.get_children():
		if (c is Node2D && !c is IActive):
			all_actives += get_all_actives(c)
		elif (c is IActive):
			all_actives.append(c)
			
	return all_actives
	
func get_duplication_phldrs(parent=self):
	var duplication_phldrs = []
	for p in parent.get_children():
		if (!p is IDuplication || p.is_multiple_duplication):
			duplication_phldrs += get_duplication_phldrs(p)
		else:
			duplication_phldrs.append(p)
			
	return duplication_phldrs

func duplication_node_performed():
	if (duplication_phldrs.all(func(d) : return d == null || d.duplication_performed)):
		ready_to_load_spell = true

func await_resource_loaded(c: Callable, retry_timeout: float=0.05):
	while c.get_object() != null && !c.call():
		await c.get_object().get_tree().create_timer(retry_timeout).timeout

