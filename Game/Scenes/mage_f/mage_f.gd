extends IHeros

var direction = Vector2.ZERO
var service_health = preload("res://Game/Services/service_health.gd").new()

@export var orb_kind: MageOrb.OrbKind
var orb

func _ready():
	health_bar = $health_bar
	if is_multiplayer_authority():
		await super._ready()
		
		orb = $spells_mage_f/ctrlr_mage_f_1/spells_mage_f_1
		animation = $AnimatedSprite2D
		self.show()

func _process(delta):
	super._process(delta)

func update_orb_kind(orb_kind_update):
	if orb == null:
		await await_resource_loaded(func(): return orb != null)
	
	orb_kind = orb_kind_update
	orb.animation.animation = MageOrb.OrbKind.keys()[orb_kind]
	orb.animation.frame = orb.animation.sprite_frames.get_frame_count(orb.animation.animation) - 1

