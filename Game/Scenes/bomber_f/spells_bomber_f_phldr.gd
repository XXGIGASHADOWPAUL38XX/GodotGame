extends IPlaceholderSpells

var dp_bomb
var all_shoots
var all_bombs

var active_bomb_file: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	dp_bomb = $ctrlr_spell_1/dp_bomb
	await super._ready()
	
	all_shoots = get_all_shoots()
	all_bombs = get_all_bombs()

# -------------- FUNCTIONS BOMBS ---------------
func get_all_bombs():
	return dp_bomb.get_children().filter(func(b): return b is IActive)

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
	#!!
	return all_actives.filter(func(a): return a.name.begins_with("shoot"))

