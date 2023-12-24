extends "res://Game/Interface/IDamagingSpell.gd"

var speed = 20.0
var champion
var spell
var coltdown_spell: Timer
var pos_offset
var is_launched = false

var distance: float = 25  # Distance from center_object
var rotation_speed: float = 2  # Adjust as needed
var current_angle: float = 0.0
var direction

func _ready():
	if is_multiplayer_authority():
		spell = $speical_ranger_anim
		
		super._ready()
		self.func_on_entity_entered.append(Callable(get_parent().get_node('target_ranger_m_3'), 'marked').bind(self))
		
		champion = ServiceScenes.championNode

func _process(delta):
	if is_multiplayer_authority():
		if self.visible && !is_launched:
			current_angle += rotation_speed * delta
			direction = Vector2(cos(current_angle), sin(current_angle))
			self.position = ServiceScenes.championNode.position + (direction * distance)

func spell_movement():
	is_launched = true
	self.position = champion.position + ServiceSpell.set_in_front_mouse(champion, get_global_mouse_position(), 35)

	var direction = get_global_mouse_position() - self.position
	direction = direction.normalized()

	for i in range(15):
		self.position += (direction * speed)
		await get_tree().create_timer(0.01).timeout
	
	self.hide()
	is_launched = false

