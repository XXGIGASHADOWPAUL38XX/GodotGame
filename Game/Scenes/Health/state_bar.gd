extends ProgressBar

var pgbars

var mapping_state_color = {
	State.StateAction.STUNNED: Color.DIM_GRAY,
	State.StateAction.IMMOBILE: Color.ORANGE
}

var current_state_bar: Timer
const decalage = 55

# Called when the node enters the scene tree for the first time.
func _ready():
	pgbars = get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_multiplayer_authority() && self.visible:
		self.value = current_state_bar.time_left
		self.position = Vector2(
			pgbars.attached_entity.position.x + (self.size.x / -2), 
			pgbars.attached_entity.position.y + (decalage * -1)
		)

func init_state_bar(curr_state_action: SingleState):
	self.get_theme_stylebox("fill", "ProgressBar").bg_color = mapping_state_color[curr_state_action.state]
	
	current_state_bar = curr_state_action.timer
	current_state_bar.timeout.connect(func(): self.hide())
	
	self.max_value = current_state_bar.wait_time
	self.show()
	
