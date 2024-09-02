extends IDuplication

var champions
var all_heros = [
	HerosDescription.new('mage_f', HerosKind.Kind.MAGE, 4, 1, 2, 2, 2, 3),
	HerosDescription.new('warrior_m', HerosKind.Kind.FIGHTER, 3, 3, 2, 1, 2, 1),
	HerosDescription.new('ranger_m', HerosKind.Kind.MARKSMANN, 4, 1, 3, 1, 2, 2),
	HerosDescription.new('ninja_m', HerosKind.Kind.ASSASSIN, 4, 1, 4, 1, 1, 4),
	HerosDescription.new('healer_f', HerosKind.Kind.SUPPORT, 2, 1, 1, 4, 3, 1),
	HerosDescription.new('tank_m', HerosKind.Kind.TANK, 1, 4, 2, 1, 3, 3),
	HerosDescription.new('witcher_f', HerosKind.Kind.MAGE, 4, 1, 3, 1, 2, 2),
	HerosDescription.new('bomber_f', HerosKind.Kind.MARKSMANN, 4, 1, 1, 2, 3, 1),
	HerosDescription.new('fighter_f', HerosKind.Kind.ASSASSIN, 4, 1, 3, 1, 2, 4)
]

var name_callable: Callable = func dp_callable_name(id):
	return dp_node.name + "_R" + str(id)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	# VALUES TO OVERRIDE #
	dp_number = all_heros.size()
	dp_callable_name = name_callable
	dp_node = get_parent().get_node("champion")
	await super._ready()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
