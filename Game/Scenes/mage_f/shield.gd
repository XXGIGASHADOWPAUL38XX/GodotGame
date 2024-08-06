extends ProgressBar

var service_time = preload("res://Game/Services/service_time.gd").new()

var coltdown = Timer.new()
var health_bar
const MIN_SIZE_SHIELD = 4

# Called when the node enters the scene tree for the first time.
func _ready():
	health_bar = get_parent().get_node('health_bar')

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_multiplayer_authority(): 
		if self.size.x > MIN_SIZE_SHIELD:
			if self.visible == false:
				self.show()
				
			self.position = Vector2(
				health_bar.size.x * (health_bar.value / health_bar.max_value) / 2,
				-35
			)
		else:
			self.hide()
		
func set_shield(value_shield, time):
	if is_multiplayer_authority():
		coltdown = service_time.init_timer(self, time)
		coltdown.timeout.connect(shield_expired)
		coltdown.start()
		set_value(value_shield)
		ServiceScenes.championNode.state_shielded = State.StateShielded.SHIELDED

func set_value(value_shield):
	self.size.x = value_shield * (health_bar.size.x / health_bar.max_value) + MIN_SIZE_SHIELD

func shield_expired():
	self.size.x = MIN_SIZE_SHIELD
	ServiceScenes.championNode.state_shielded = State.StateShielded.NULL

func remaining_damage(incoming_damage):
	if incoming_damage >= self.size.x:
		shield_expired()
		return incoming_damage - self.size.x

	set_value(self.size.x - incoming_damage)
	return 0
