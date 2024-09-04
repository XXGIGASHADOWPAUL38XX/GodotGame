extends IPlaceholderSpells

var dp_10x_bomb
var all_shoots
var all_bombs

var active_bomb_file: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	dp_10x_bomb = $ctrlr_spell_1/dp_10x_bomb
	await super._ready()
	
	all_shoots = get_all_shoots()
	all_bombs = get_all_bombs(dp_10x_bomb)

# -------------- FUNCTIONS BOMBS ---------------
func get_all_bombs(bomb_parent):
	var bombs = []
	
	for c in bomb_parent.get_children():
		if c is IActive:
			bombs.append(c)
		elif c.get_children().size() != 0:
			bombs += get_all_bombs(c)
			
	return bombs

func get_inactives_bombs():
	return all_bombs.filter(func(b): return !b.visible)

func get_inactive_bomb():
	var inactive_bomb
	
	if get_inactives_bombs().size() > 0:
		inactive_bomb = get_inactives_bombs()[0]
		active_bomb_file.append(inactive_bomb)
	else:
		inactive_bomb = active_bomb_file[0]
		active_bomb_file.remove_at(0)
	
	return inactive_bomb

# -------------- FUNCTIONS SHOOTS ---------------
func get_all_shoots():
	return [$ctrlr_spell_1/dp_shoot_1, $ctrlr_spell_4/dp_spell_4].map(func(shoot_parent):
		return shoot_parent.get_children().filter(func(child): return child is IActive)
	).reduce(func(a, b): return a + b)

