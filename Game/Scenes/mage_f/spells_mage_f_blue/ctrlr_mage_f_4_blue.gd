extends IControllerKeyPressed

var dp_node: IDuplication
var dp_node_spell_2

func _ready():
	key = KEY_SPACE
	coltdown_time = 12
	
	dp_node_spell_2 = get_parent().get_node("ctrlr_mage_f_2_blue").get_node('dp_mage_f_2_blue')
	dp_node = $dp_mage_f_4_blue
	
	await super._ready()
	
	cond_spells.append(Callable(self, 'launch_spell_cond_1'))
	cond_spells.append(Callable(self, 'launch_spell_cond_2'))

func active():
	super.active()
	if get_current_orb().number_orb == all_orbs().size():
		var matching_orb_s_2 = get_matching_orb_s_2()
		matching_orb_s_2.activation_f4()
		get_current_orb().can_active(matching_orb_s_2)
		
		increment_current_orb()
	
func increment_current_orb():
	dp_node.current_orb = (dp_node.current_orb % 4) + 1

func get_current_orb():
	return all_orbs().filter(func(s): return s.number_orb == dp_node.current_orb)[0]
	
func all_orbs():
	return dp_node.get_children().filter(func(s): return s is IActive)

func launch_spell_cond_1():
	return ServiceScenes.championNode.orb_kind == get_current_orb().orb_kind
	
func launch_spell_cond_2():
	return dp_node_spell_2.get_children().filter(func(s): return s is IActive).all(
		func(s): return s.should_rotate_champ
	)

func get_matching_orb_s_2():
	return dp_node_spell_2.get_children().filter(
		func(s): return s is IActive && s.number_orb == get_current_orb().number_orb
	)[0]
