extends IHeros

var direction = Vector2.ZERO
var service_health = preload("res://Game/Services/service_health.gd").new()

@export var orb_kind: MageOrb.OrbKind:
	get:
		return orb_kind
	set(value):
		orb_kind = value
		$spells_mage_f.orb_additionnal_operations(orb_kind)
		
var orb
var anim_orb_hide

func _ready():
	if is_multiplayer_authority():
		orb = $spells_mage_f/ctrlr_mage_f_1/spells_mage_f_1
		anim_orb_hide = $spells_mage_f/ctrlr_mage_f_1/anim_orb_hide
		self.show()
		
	await super._ready()

func _process(delta):
	super._process(delta)

func update_orb_kind(orb_kind_update):
	if orb == null:
		await await_resource_loaded(func(): return orb != null)
	
	orb_kind = orb_kind_update
	orb.animation.animation = MageOrb.OrbKind.keys()[orb_kind]
	anim_orb_hide.animation = MageOrb.OrbKind.keys()[orb_kind]

