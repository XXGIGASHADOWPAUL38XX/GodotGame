extends IHeros

var direction = Vector2.ZERO
var service_health = preload("res://Game/Services/service_health.gd").new()

@export var orb_kind: MageOrb.OrbKind

@onready var spell_orb = $spells_mage_f/ctrlr_mage_f_1/spells_mage_f_1
@onready var orb = $spells_mage_f/ctrlr_mage_f_1/orb_mage_f_1
@onready var anim_orb_hide = $spells_mage_f/ctrlr_mage_f_1/anim_orb_hide

func _ready():
	if is_multiplayer_authority():
		self.show()
		
	await super._ready()

func _process(delta):
	super._process(delta)

func update_orb_kind(orb_kind_update):
	if spell_orb == null:
		await resource_awaiter.await_resource_loaded(func(): return spell_orb != null)
	
	ServiceScenes.championNode.add_state(
		self, 'states_action', State.StateAction.CONCENTRATE, 
		ServiceSpell.animation_duration($spells_mage_f/ctrlr_mage_f_1.anim_orb_hide)
	)
	$spells_mage_f/ctrlr_mage_f_1.anim_orb_hide.active()
		
	anim_orb_hide.animation = MageOrb.OrbKind.keys()[orb_kind]
	
	orb_kind = orb_kind_update
	
	spell_orb.animation.animation = MageOrb.OrbKind.keys()[orb_kind]
	orb.animation.animation = MageOrb.OrbKind.keys()[orb_kind]
	
	if orb_kind != MageOrb.OrbKind.BLUE:
		$spells_mage_f/spells_mage_f_blue/ctrlr_mage_f_2_blue/dp_mage_f_2_blue.get_children().filter(
			func(s): return s is IActive).map(func(s): s.hide()
		)
	
	$spells_mage_f/ctrlr_mage_f_1.orb.unactive()
