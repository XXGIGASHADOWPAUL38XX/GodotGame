extends HBoxContainer

var multip_sync_path = "./../../MultiplayerSynchronizer"

var service_time = preload("res://Game/Services/service_time.gd").new()

var spell3_elements = {
	MageOrb.OrbKind.GOLD: preload("res://Game/Ressources/Heros/mage_f/spell3_1_mage.png"),
	MageOrb.OrbKind.BLUE: preload("res://Game/Ressources/Heros/mage_f/spell3_2_mage.png"),
	MageOrb.OrbKind.RED: preload("res://Game/Ressources/Heros/mage_f/spell3_3_mage.png")
}

var sorted_slots = []
var champion

var cd_spell = 1.0
var spell: AnimatedSprite2D
var coltdown_spell: Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		await CustomResourceLoader.await_resource_loaded(func(): return ServiceScenes.championNode != null)
		
		champion = ServiceScenes.championNode
		sorted_slots = spell3_elements.keys()
		sorted_slots.shuffle()
		assign_to_solts()
		champion.update_orb_kind(sorted_slots[sorted_slots.size() - 1])
		
		coltdown_spell = service_time.init_timer(self, cd_spell)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_multiplayer_authority():
		self.position = champion.position + Vector2(-14, -10)
		if Input.is_key_pressed(KEY_E) && coltdown_spell.time_left == 0:
			coltdown_spell.start()
			next_element()

func next_element():
	var next_possible_slots = spell3_elements.keys().filter(func(slot): 
		return sorted_slots.find(slot) != sorted_slots.size() - 1
	)

	champion.update_orb_kind(sorted_slots[0])
	animate_texture(spell3_elements[champion.orb_kind])
	
	sorted_slots.append(next_possible_slots.pick_random())
	sorted_slots.remove_at(0)
	assign_to_solts()
	
func assign_to_solts():
	var slots = self.get_children().filter(func(obj): return obj is TextureRect)
	for i in range(slots.size()):
		self.get_child(i).texture = spell3_elements[sorted_slots[i]]
		
func animate_texture(txtrRect: CompressedTexture2D):
	var animation_txtrRect = TextureRect.new()
	animation_txtrRect.size = Vector2(25, 25)
	animation_txtrRect.position = animation_txtrRect.size * -0.5
	animation_txtrRect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	
	animation_txtrRect.texture = txtrRect
	champion.add_child(animation_txtrRect)
	
	animation_txtrRect.modulate.a = 0.6
	for i in range(10):
		animation_txtrRect.modulate.a -= 0.06
		animation_txtrRect.size *= 1.025
		await get_tree().create_timer(0.03).timeout
		
	animation_txtrRect.queue_free()

func await_resource_loaded(c: Callable, retry_timeout: float=0.05):
	while !c.call():
		await self.get_tree().create_timer(retry_timeout).timeout
		
	return true