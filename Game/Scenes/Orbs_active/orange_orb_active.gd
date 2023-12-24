extends "res://Game/Interface/IDamagingSpell.gd"

var cd = 12.0
var coltdown: Timer

var center_object: Node2D
var distance: float = 60.0  # Distance from center_object
var rotation_speed: float = 2  # Adjust as needed
var current_angle: float = 0.0
var direction

# Called when the node enters the scene tree for the first time.
func _ready():
	coltdown = service_time.init_timer(self, cd) 
	self.area_entered.connect(_on_area_entered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_multiplayer_authority():
		super.check_collisions()
		if Input.is_key_pressed(
		KEY_D) && coltdown.time_left == 0:
			special()
			coltdown.start()
			
		if self.visible:
			self.position = ServiceScenes.championNode.position
			rotate(delta)

func special():
	self.show()
	await get_tree().create_timer(15).timeout
	self.hide()
		
func _on_area_entered(spell: Node2D):
	if self.visible && spell.name.begins_with('spell'):
		spell.position = Vector2.ZERO
