extends ProgressBar

var service_time = preload("res://Game/Services/service_time.gd").new()
var pgbars

var coltdown = Timer.new()

const MARGIN_MIN = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pgbars = get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_multiplayer_authority(): 
		if self.visible:
			self.position = Vector2(
				(pgbars.health_bar.position.x + (pgbars.health_bar.size.x * (pgbars.health_bar.value / pgbars.health_bar.max_value))) * pgbars.health_bar.scale.x,
				pgbars.health_bar.position.y * pgbars.health_bar.scale.y
			)
		
func set_shield(value_shield, time):
	if is_multiplayer_authority():
		coltdown = service_time.init_timer(self, time)
		coltdown.timeout.connect(shield_expired)
		coltdown.start()
		value_shield(value_shield)
		
		ServiceScenes.championNode.add_state(self, 'states_shielded', State.StateShielded.SHIELDED)

func value_shield(value_shield):
	self.max_value = value_shield
	self.value = value_shield
	self.size.x = value_shield * (pgbars.health_bar.size.x / pgbars.health_bar.max_value)
	self.show()

func shield_expired():
	ServiceScenes.championNode.remove_state(self, 'states_shielded')
	self.hide()

func remaining_damage(incoming_damage):
	if incoming_damage >= self.value:
		shield_expired()
		return incoming_damage - self.value

	set_value(self.value - incoming_damage)
	return 0
