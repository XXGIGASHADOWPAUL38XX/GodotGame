extends IDuplication

var name_callable: Callable = func dp_callable_name(id):
	return dp_node.name + "_R" + str(id)
	
var health_gem = Gem.new('health_gem', [GemUtils.GemCategory.DURABILITY], [], 0.0, 5.0, 0.0, "health_gem")
var attack_gem = Gem.new('attack_gem', [GemUtils.GemCategory.DAMAGE], [], 5.0, 0.0, 0.0, "attack_gem")
var armor_gem = Gem.new('armor_gem', [GemUtils.GemCategory.DURABILITY], [],  0.0, 0.0, 5.0, "armor_gem")
var speed_gem = Gem.new('speed_gem', [GemUtils.GemCategory.UTILITY], [],  0.0, 5.0, 0.0, "speed_gem")

var shockwave_gem = Gem.new('shockwave_gem', 
	[GemUtils.GemCategory.DURABILITY],
	[health_gem, health_gem, attack_gem],
	 0.0, 0.0, 0.0, 
	"Emet une vague de dêgats quand des dêgats sont recus"
)
var drone_gem = Gem.new('drone_gem', 
	[GemUtils.GemCategory.DAMAGE], 
	[attack_gem, attack_gem, speed_gem],
	0.0, 0.0, 0.0, 
	"Invoque un drône tireur"
)
var slice_gem = Gem.new('slice_gem', 
	[GemUtils.GemCategory.DAMAGE, GemUtils.GemCategory.UTILITY], 
	[attack_gem, attack_gem, speed_gem],
	0.0, 0.0, 0.0, 
	"Occtroie une charge rapide effectuant des degats"
)
var earthquake_gem = Gem.new('earthquake_gem', 
	[GemUtils.GemCategory.DURABILITY], 
	[armor_gem, armor_gem, health_gem],
	0.0, 0.0, 0.0, 
	"Créé un séisme infligant des dêgats autour de soi"
)
var block_gem = Gem.new('block_gem', 
	[GemUtils.GemCategory.DURABILITY, GemUtils.GemCategory.UTILITY], 
	[armor_gem, armor_gem, health_gem],
	0.0, 0.0, 0.0, 
	"Bloque les projectiles ennemis"
)
var boost_gem = Gem.new('boost_gem', 
	[GemUtils.GemCategory.DURABILITY, GemUtils.GemCategory.DAMAGE], 
	[armor_gem, health_gem, attack_gem],
	0.0, 0.0, 0.0, 
	"Augmente les stats temporairement à chaque coup donné"
)
var mark_gem = Gem.new('mark_gem', 
	[GemUtils.GemCategory.DAMAGE], 
	[attack_gem, attack_gem, speed_gem],
	0.0, 0.0, 0.0, 
	"Chaque sort met une marque à l'ennemi qui explode une fois stackée"
)
var cleanse_gem = Gem.new('cleanse_gem', 
	[GemUtils.GemCategory.UTILITY], 
	[attack_gem, attack_gem, speed_gem],
	0.0, 0.0, 0.0, 
	"Purge tous les contrôles"
)

var subitems = [health_gem, attack_gem, armor_gem, speed_gem]
var items = [shockwave_gem, drone_gem, slice_gem, earthquake_gem, block_gem, boost_gem, mark_gem, cleanse_gem]

# Called when the node enters the scene tree for the first time.
func _ready():
	ServiceScenes.loading_async.add_loading(self.name + "actives", "Charvisionent des actifs du shop")
	
	# VALUES TO OVERRIDE #
	dp_number = items.size()
	dp_callable_name = name_callable
	dp_node = get_parent().get_node("item_buildpath")
	await super._ready()
	
	duplication_performed.connect(func(): ServiceScenes.loading_async.remove_loading(self.name + "actives"))
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
