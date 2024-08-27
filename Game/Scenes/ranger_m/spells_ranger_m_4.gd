extends IControllerKeyPressed

var anim_pre_spell
var anim_count
var active_spell
var mark_number: int:
	get:
		return mark_number
	set(value):
		mark_number = min(anim_count.sprite_frames.get_frame_count(anim_count.animation) - 1, value)
		mark_number_value_changed(mark_number)

func _ready():
	key = KEY_SPACE
	coltdown_time = 12
	
	cond_spells.append(Callable(self, 'can_launch_spell'))
	await super._ready()
	
	anim_pre_spell = $anim_pre_spell as AnimatedSprite2D
	anim_count = $anim_count
	active_spell = $active_ranger_m_4
	
	anim_pre_spell.animation_finished.connect(Callable(active_spell, 'active'))

func active():
	anim_pre_spell.can_active()
	active_spell.position = anim_pre_spell.position
	mark_number -= 1

func mark_number_value_changed(frame_number):
	$anim_count.frame = frame_number

func can_launch_spell():
	return mark_number != 0
