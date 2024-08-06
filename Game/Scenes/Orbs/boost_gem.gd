extends AnimatedSprite2D

var augment: int = 0
const MAX_AUGMENT = 5
var service_time = preload("res://Game/Services/service_time.gd").new()
var item_class = preload("res://Game/Classes/Item/item.gd").new()

var coltdown_wave = Timer.new()
var cd_wave = 3.0

func _ready():
	if is_multiplayer_authority():
		coltdown_wave = service_time.init_timer(self, cd_wave)
		coltdown_wave.timeout.connect(
			func(): 
				remove_stats()
				augment = 0
		)
		
		ServiceScenes.championNode.func_hit.append(Callable(self, 'special'))
		
func special():
	if is_multiplayer_authority():
		coltdown_wave.start()
		
		if augment < MAX_AUGMENT:
			augment += 1
			add_stats()
			coltdown_wave.start() #!!
			self.position = ServiceScenes.championNode.position
			self.scale = Vector2(0.08, 0.08)
			self.modulate.a = 0.4
			self.show()
			
			for i in range(8):
				self.scale = self.scale * 1.03
				self.modulate.a += 0.06
				await get_tree().create_timer(0).timeout
				
			self.hide()
		else:
			ServiceScenes.championNode.modulate = Color.ORANGE

func add_stats():
	ServiceStats.update_stats_local(ServiceScenes.championNode, "damage_bonus_flat", 1, UpdateMode.UpdateMode.ADD)
	ServiceStats.update_stats_local(ServiceScenes.championNode, "armor_bonus_flat", 1, UpdateMode.UpdateMode.ADD)

func remove_stats():
	ServiceStats.update_stats_local(ServiceScenes.championNode, "damage_bonus_flat", -augment, UpdateMode.UpdateMode.ADD)
	ServiceStats.update_stats_local(ServiceScenes.championNode, "armor_bonus_flat", -augment, UpdateMode.UpdateMode.ADD)
