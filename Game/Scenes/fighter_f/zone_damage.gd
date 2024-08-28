extends IDamagingSpell

var base_scale

@export var bonus_damage_count: float
@export var bonus_damage_count_ratio: float

func _ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 5.0
		damage_ratio = 0.1
		
		bonus_damage_count = 2.0
		bonus_damage_count_ratio
		# ------------------------------------ #
		
		base_scale = self.scale
		
		super._ready()

func _process(_delta):
	pass

func active(): 
	self.show()
	animation.play()

	self.position = champion.position
	
	for i in range(10):
		self.position = champion.position
		self.scale *= 1.12
		self.modulate.a -= 0.075
		await get_tree().create_timer(0).timeout 
		
	self.hide()
	self.scale = base_scale
	self.modulate.a = 1

func output_damage_f(champion_hitted):
	var bonus_points = get_parent().get_node("counter_count").frame 
	return (damage_base + (bonus_points * bonus_damage_count) + (
			(damage_ratio + (bonus_damage_count_ratio * bonus_points)) * champion.damage_final)) * (
			1 - (champion_hitted.armor_final / 100))

func set_multiplayer_properties():
	super.set_multiplayer_properties()
	
	multip_sync.replication_config.add_property(self.name + ":bonus_damage_count")
	multip_sync.replication_config.add_property(self.name + ":bonus_damage_count_ratio")
	
	
