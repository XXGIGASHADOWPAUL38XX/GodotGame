extends "res://Game/Interface/IDamagingSpell.gd"

var speed = 20.0
var champion
var throw_direction = Vector2.RIGHT
var cd_spell2 = 8.0
var spell2: AnimatedSprite2D
var coltdown_spell2: Timer
var HUD

func _ready():	
	if is_multiplayer_authority():
		super._ready()
		self.hide()
		champion = ServiceScenes.championNode
		spell2 = $Spells_warrior_anim_2
		coltdown_spell2 = service_time.init_timer(self, cd_spell2)

func _process(_delta):
	if is_multiplayer_authority():
		if Input.is_key_pressed(KEY_Z) && coltdown_spell2.time_left == 0:
			coltdown_spell2.start()
			spell2_shield()
			
		if (HUD == null):
			HUD = ServiceScenes.getMainScene().get_node('stats_heros')
		else:
			HUD.bindTo(coltdown_spell2, 2)

func spell2_shield():
	self.show()

	spell2.play("spell2_shield")

	for i in range(15):
		self.position = champion.position + ServiceSpell.set_in_front_mouse(champion, get_global_mouse_position(), 0)
		await get_tree().create_timer(0.05).timeout

	spell2.stop()
	self.hide()




