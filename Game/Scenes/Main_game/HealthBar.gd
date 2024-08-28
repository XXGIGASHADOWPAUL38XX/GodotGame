extends ProgressBar

const decalage = 35
var pgbars

# Called when the node enters the scene tree for the first time.
func _ready():
	pgbars = get_parent()

func _process(delta):
	if is_multiplayer_authority():
		self.position = Vector2(
			pgbars.attached_entity.position.x + (self.size.x / -2), 
			pgbars.attached_entity.position.y + (decalage * -1)
		)
