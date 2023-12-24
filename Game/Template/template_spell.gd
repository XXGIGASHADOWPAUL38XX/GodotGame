extends CharacterBody2D

var speed = 20.0
var champion
var throw_direction = Vector2.RIGHT
var cd_spell = 3.0
var spell: AnimatedSprite2D
var coltdown_spell: Timer
var service_time = prepreload("res://Game/Services/service_time.gd").new()
var coltdown_display_spell

func _ready():
	self.scale = Vector2(0.1, 0.1)
	champion = ServiceScenes.championNode
	spell = $Spells_mage_anim
	coltdown_spell = service_time.init_timer(self, cd_spell)
	
	coltdown_display_spell = get_tree().root.get_node('main_game').get_node('spell1_displayBar')

func _process(delta):
	coltdown_display_spell.bindTo(coltdown_spell)
	
	if Input.is_key_pressed(KEY_A) && coltdown_spell.time_left == 0:
		coltdown_spell.start()
		spell_function()
		
func spell_function():
	spell.play("spell1_launch")
	spell.stop()
	

