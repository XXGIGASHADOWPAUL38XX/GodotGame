extends "res://Game/Interface/IDamagingSpell.gd"

var speed = 20.0
var champion
var throw_direction = Vector2.RIGHT
var cd_spell1 = 4.0
var spell1: AnimatedSprite2D
var coltdown_spell1: Timer
var HUD

func _ready():
	if is_multiplayer_authority():
		super._ready()
		self.hide()
		champion = ServiceScenes.championNode
		spell1 = $Spells_warrior_anim_1
		coltdown_spell1 = service_time.init_timer(self, cd_spell1)

func _process(_delta):
	if is_multiplayer_authority():
		if Input.is_key_pressed(KEY_A) && coltdown_spell1.time_left == 0:
			coltdown_spell1.start()
			spell1_charge()

		if (HUD == null):
			HUD = ServiceScenes.getMainScene().get_node('stats_heros')
		else:
			HUD.bindTo(coltdown_spell1, 1)
			
func spell1_charge():
	self.position = champion.position + ServiceSpell.set_in_front(champion, 10)
	self.show()
	champion.state_movement = State.StateMovement.IMMOBILE
	self.rotation = (get_global_mouse_position() - self.position).angle()

	await get_tree().create_timer(0.25).timeout
	spell1.play("spell1_charge")

	for i in range(20):
		champion.position = champion.position + ServiceSpell.set_in_front(champion, 5)
		self.position = champion.position + ServiceSpell.set_in_front(champion, 10)
		await get_tree().create_timer(0).timeout

	spell1.stop()
	champion.state_movement = State.StateMovement.NULL

	self.hide()




