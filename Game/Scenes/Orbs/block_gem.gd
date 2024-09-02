extends IActive

var collision_shape
var ring_border_active_ratio = 0.3 # ratio du collisionshape qui compte pour la 
# suppression d'un spell, permet de pas supprimer un spell au centre du spell et
# de seulement supprimer ceux sur les côtés
var block_duration = 1.5

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		collision_shape = $CollisionShape2D
		self.area_entered.connect(Callable(self, '_on_area_entered'))
		
		await super._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_multiplayer_authority() && self.visible:
		self.position = ServiceScenes.championNode.position
		rotate(delta)

func active():
	self.show()
	await get_tree().create_timer(block_duration).timeout
	self.hide()
		
func _on_area_entered(spell: Area2D):
	if self.visible && spell is IDamagingSpell && is_on_border(spell):
		spell_controller.get_inactive_anim_block().active(spell)
		
		Servrpc.send_to_id(spell.get_parent().get_parent().get_multiplayer_authority(), 
			self, "hide_spell", [spell]
		)

func hide_spell(spell):
	spell.hide()

func is_on_border(spell):
	return spell.position.distance_to(
		ServiceScenes.championNode.position) >= collision_shape.shape.radius * (1 - ring_border_active_ratio)
