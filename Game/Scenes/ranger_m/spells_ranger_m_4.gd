extends "res://Game/Interface/IDamagingSpell.gd"

var speed = 20.0
var champion
var throw_direction = Vector2.RIGHT
var cd_spell4 = 1.5
var spell4: AnimatedSprite2D
var coltdown_spell4: Timer
var HUD
var animation
var pre_animation: AnimatedSprite2D
var mines_count

func _ready():
	if is_multiplayer_authority():
		super._ready()
		self.hide()

		mines_count = get_parent().get_node('animations').get_node('spells_4_count')
		pre_animation = get_parent().get_node('animations').get_node('spells_4_pre_anim')
		champion = ServiceScenes.championNode
		coltdown_spell4 = service_time.init_timer(self, cd_spell4)
		animation = $Spells_ranger_anim_4

func _process(_delta):
	if is_multiplayer_authority():
		if Input.is_key_pressed(KEY_SPACE) && coltdown_spell4.time_left == 0 && mines_count.frame > 0:
			coltdown_spell4.start()
			spell4_pre_mine()
		
		if (HUD == null):
			HUD = ServiceScenes.getMainScene().get_node('stats_heros')
		else:
			HUD.bindTo(coltdown_spell4, 4)

func spell4_pre_mine():
	if is_multiplayer_authority():
		pre_animation.position = get_global_mouse_position()
		pre_animation.play("default")
		pre_animation.show()
		
		if !(pre_animation.animation_finished.is_connected(spell4_mine)):
			pre_animation.animation_finished.connect(spell4_mine)
		
func spell4_mine():
	pre_animation.hide()
	self.global_position = pre_animation.global_position
	mines_count.frame -= 1
	self.show()
	animation.play("spell_4_pre_anim")
	
	await animation.animation_finished
	self.hide()
	
