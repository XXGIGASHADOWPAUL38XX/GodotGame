extends IHeros

var direction = Vector2.ZERO
var service_health = preload("res://Game/Services/service_health.gd").new()

@export var orb_kind: MageOrb.OrbKind

@onready var orb = $spells_mage_f/ctrlr_mage_f_1/spells_mage_f_1
@onready var anim_orb_hide = $spells_mage_f/ctrlr_mage_f_1/anim_orb_hide

func _ready():
	if is_multiplayer_authority():
		self.show()
		
	await super._ready()

func _process(delta):
	super._process(delta)

func update_orb_kind(orb_kind_update):
	if orb == null:
		await resource_awaiter.await_resource_loaded(func(): return orb != null)
	
	if $spells_mage_f/ctrlr_mage_f_1.orb.visible:
		ServiceScenes.championNode.add_state(
			self, 'states_action', State.StateAction.CONCENTRATE, 
			ServiceSpell.animation_duration($spells_mage_f/ctrlr_mage_f_1.anim_orb_hide)
		)
		await $spells_mage_f/ctrlr_mage_f_1.anim_orb_hide.active()
		
	orb_kind = orb_kind_update
	orb.animation.animation = MageOrb.OrbKind.keys()[orb_kind]
	anim_orb_hide.animation = MageOrb.OrbKind.keys()[orb_kind]
	
	$spells_mage_f.orb_additionnal_operations(orb_kind)

