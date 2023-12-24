extends "res://Game/Interface/IDamagingSpell.gd"

var speed = 20.0
var champion
var throw_direction = Vector2.RIGHT
var cd_spell = 5.0
var spell: AnimatedSprite2D
var coltdown_spell: Timer
var HUD
var passive

func _ready():	
	if is_multiplayer_authority():
		super._ready()
		self.hide()
		
		champion = ServiceScenes.championNode
		passive = get_parent().get_node('passive_mage_f')
		
		spell = $Spells_mage_explode
		coltdown_spell = service_time.init_timer(self, cd_spell)

func _process(_delta):
	if is_multiplayer_authority():
		if Input.is_key_pressed(KEY_Z) && coltdown_spell.time_left == 0:
			coltdown_spell.start()
			spell_function()
			
		if (HUD == null):
			HUD = ServiceScenes.getMainScene().get_node('stats_heros')
		else:
			HUD.bindTo(coltdown_spell, 2)
		
func spell_function():
	self.position = passive.position
	self.show()
	spell.play("spell2_explode")

	await get_tree().create_timer(0.5).timeout
	self.position = passive.position
		
	await get_tree().create_timer(0.5).timeout
	spell.stop()
	self.hide()
	

