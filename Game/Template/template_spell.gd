extends CharacterBody2D

var speed = 20.0
var champion
var throw_direction = Vector2.RIGHT
var cd_spell = 3.0
var spell: AnimatedSprite2D
var coltdown_spell: Timer
var service_time = ServiceTime.new()
var coltdown_display_spell

func _ready():
	self.scale = Vector2(0.1, 0.1)
	champion = ServiceScenes.championNode
	spell = $Spells_mage_anim
	coltdown_spell = service_time.init_timer(self, cd_spell)
	
	coltdown_display_spell = get_tree().root.get_node('main_game').get_node('spell1_displayBar')

func _process(delta):
	coltdown_display_spell.bindTo(coltdown_spell)
	
	if Input.is_key_pressed(ServiceSettings.keys_values['key_spell_1']) && coltdown_spell.time_left == 0:
		coltdown_spell.start()
		spell_function()
		
func spell_function():
	spell.play("spell_launch")
	spell.stop()
	

