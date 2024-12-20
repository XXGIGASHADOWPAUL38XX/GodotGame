extends IDamagingSpell

var allies_nodes
var mark_overall_node

# Called when the node enters the scene tree for the first time.
func _ready():
	# DEFINITION VARIABLES IDAMAGING SPELL #
	damage_base = 5.0
	damage_ratio = 0.08
	# ------------------------------------ #
		
	mark_overall_node = get_parent()
	allies_nodes = ServiceScenes.entities.alliesNode
	await super._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func active():
	allies_nodes.shuffle()
	
	self.position = mark_overall_node.mark.position
	var speed = 8

	self.show()
	
	for ally in allies_nodes:
		while !ServiceSpell.is_close_to(ally, self, 10):
			var direction = ally.position - self.position
			var velocity = direction.normalized() * speed
			
			self.position += velocity
			await get_tree().create_timer(0.01).timeout
		
	self.hide()

func output_damage_f(champion_hitted):
	var damage = damage_base + (damage_ratio * champion.damage_final) * (1 - (champion_hitted.armor_final / 100))
	return damage * -1
