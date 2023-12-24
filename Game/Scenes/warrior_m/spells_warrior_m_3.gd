extends "res://Game/Interface/IDamagingSpell.gd"

var speed = 20.0
var champion
var throw_direction = Vector2.RIGHT
var cd_spell3 = 3.0
var spell3: AnimatedSprite2D
var coltdown_spell3: Timer
var HUD

func _ready():	
	if is_multiplayer_authority():
		super._ready()
		self.hide()
		champion = ServiceScenes.championNode
		spell3 = $Spells_warrior_anim_3
		coltdown_spell3 = service_time.init_timer(self, cd_spell3)

func _process(_delta):
	if is_multiplayer_authority():
		if Input.is_key_pressed(KEY_E) && coltdown_spell3.time_left == 0:
			coltdown_spell3.start()
			spell3_attack()
			
		if (HUD == null):
			HUD = ServiceScenes.getMainScene().get_node('stats_heros')
		else:
			HUD.bindTo(coltdown_spell3, 3)

func spell3_attack():
	self.position = champion.position + ServiceSpell.set_in_front_mouse(champion, get_global_mouse_position(), 30)
	champion.state_movement = State.StateMovement.IMMOBILE
	self.show()
	
	self.rotation = (get_global_mouse_position() - self.position).angle()
	spell3.play("spell3_attack")

	await get_tree().create_timer(0.45).timeout
	
	spell3.stop()
	self.hide()
	champion.state_movement = State.StateMovement.NULL



