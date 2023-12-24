extends "res://Game/Interface/ISpell.gd"

var player # INSTANCIE LORS DE LA DUPLICATION
var animation

func _ready():
	if is_multiplayer_authority():
		animation = $special_healer_f_anim
		animation.animation_finished.connect(stop_spell)
		CONF_DETECT_WITH = ServiceScenes.alliesNode
		super._ready()
			
func _process(_delta):
	if self.visible:
		self.global_position = player.position
			
func spell_purge_allies():
	Servrpc.any(ServiceStats, 'update_stats_local', [player, 'speed_bonus_ratio', player.speed_bonus_ratio + 0.4])
	player.state_movement = State.StateMovement.NULL
	animation.play('default')
	
	self.modulate.a = 0.5
	self.global_position = player.position
	self.show()

	await get_tree().create_timer(1.5).timeout
	Servrpc.any(ServiceStats, 'update_stats_local', [player, 'speed_bonus_ratio', player.speed_bonus_ratio - 0.4])
	
func stop_spell():
	for i in range(10):
		self.global_position = player.position
		self.modulate.a -= 0.05
		await get_tree().create_timer(0.02).timeout

	self.hide()
	

