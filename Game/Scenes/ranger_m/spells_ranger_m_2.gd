extends "res://Game/Interface/IDamagingSpell.gd"

var speed = 20.0
var champion
var throw_direction = Vector2.RIGHT
var cd_spell2 = 5.0
var spell2: AnimatedSprite2D
var coltdown_spell2: Timer
var HUD
var animation
var missile

func _ready():
	self.hide()
	self.func_on_entity_entered.append(Callable(get_parent().get_node('target_ranger_m_3'), 'marked').bind(self))

	missile = get_parent().get_node('spells_ranger_m_1')
	champion = ServiceScenes.championNode
	coltdown_spell2 = service_time.init_timer(self, cd_spell2)
	animation = $dash_ranger_anim_2

func _process(_delta):
	if is_multiplayer_authority():
		if Input.is_key_pressed(KEY_Z) && coltdown_spell2.time_left == 0:
			coltdown_spell2.start()
			spell2_dash()
		
		if (HUD == null):
			HUD = ServiceScenes.getMainScene().get_node('stats_heros')
		else:
			HUD.bindTo(coltdown_spell2, 2)

func spell2_dash():
	if is_multiplayer_authority():
		var speed = champion.speed_final
		champion.speed_final = 0
		self.position = champion.position
		
		self.show()
		animation.play("spell2_dash")
		
		await get_tree().create_timer(0.1).timeout
		
		champion.position += ServiceSpell.set_in_front_mouse(champion, get_global_mouse_position(), 90)
		self.position = champion.position
		champion.speed_final = speed

		await get_tree().create_timer(0.1).timeout

		missile.spell1_movement(get_parent().get_node('spells_ranger_m_1_3'))
		animation.stop()
		self.hide()
