extends IVision

# Called when the node enters the scene tree for the first time.
func _ready():
	return
	self.enabled = self.is_multiplayer_authority()
	if is_multiplayer_authority():
		# ----------------- IVision -----------------  #
		vision_area = $vision_area
		# ----------------- IVision -----------------  #
		
	super._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
