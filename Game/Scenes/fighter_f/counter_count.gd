extends IAnimation

var champion
const OFFSET_TOP = 60

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		self.frame = 0
		await super._ready()
		champion = ServiceScenes.championNode

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_multiplayer_authority():
		if self.visible:
			self.position = Vector2(champion.position.x, champion.position.y - OFFSET_TOP)

func increment():
	self.frame = min(self.sprite_frames.get_frame_count(self.animation) - 1, self.frame + 1)
