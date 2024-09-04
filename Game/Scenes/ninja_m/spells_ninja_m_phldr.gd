extends IPlaceholderSpells

var shadows: Array
var marks: Array
var dp_mark

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		dp_mark = $ctrlr_mark_ninja_m/dp_mark
		await super._ready()
		
		shadows = get_all_shadows()
		marks = get_all_marks()

func get_all_shadows():
	return all_actives.filter(func(a): return a.get('is_shadow') && a.is_shadow)

func get_all_marks():
	return dp_mark.get_children().filter(func(child): return child is IActive)
