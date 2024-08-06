extends IPlaceholderSpells

var cubes_s4

# Called when the node enters the scene tree for the first time.
func _ready():
	await super._ready()
	#!!
	await get_tree().create_timer(0.1).timeout
	cubes_s4 = $ctrlr_spell_4.cubes
