extends IControllerKeyPressed

var dp_node: IDuplication

func after_ready():
	if is_multiplayer_authority():
		key = KEY_Z
		coltdown_time = 6
		
		dp_node = $dp_mage_f_2_blue
		
		cond_spells.append(Callable(self, 'launch_spell_cond'))	
		await super.after_ready()

func active():
	super.active()
	all_orbs().map(func(o): o.can_active())

func get_current_orb():
	return all_orbs().filter(func(s): return s.number_orb == dp_node.current_orb)[0]
	
func all_orbs():
	return dp_node.get_children().filter(func(s): return s is IActive)
	
func launch_spell_cond():
	return ServiceScenes.championNode.orb_kind == get_current_orb().orb_kind
