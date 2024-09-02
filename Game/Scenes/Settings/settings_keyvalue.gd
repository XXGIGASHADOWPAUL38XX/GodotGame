extends HBoxContainer

var duplicator
var resource_awaiter = ResourceAwaiter.new()
var key
var value

var button_modulate = false
var modulate_bool = false

signal key_pressed(keycode: int)

@onready var key_label = $key/Label
@onready var value_label = $value/Label
@onready var value_button = $value/Label/Button

@onready var is_ready = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if button_modulate:
		modulate_bool = await ServiceSpell.modulate_obj(value_button, modulate_bool, 0, 1, 0.02)

func post_dp_script(id, dp_number):
	await resource_awaiter.await_resource_loaded(func(): return is_ready)
	
	duplicator = get_parent().get_node("dp_settings_keyvalue")
	key = duplicator.keys_values.keys()[id - 1]
	value = duplicator.keys_values[key]
	
	key_label.text = key
	value_label.text = OS.get_keycode_string(value)

func _on_invite_button_pressed():
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		emit_signal("key_pressed", event.keycode)
		button_modulate = false
		value_button.modulate.a = 1

func update():
	value = OS.get_keycode_string(ServiceSettings.keys_values[key])
	value_label.text = value

func _on_button_pressed():
	button_modulate = true
	
	var new_key = await key_pressed
	ServiceSettings.keys_values[key] = new_key 
	update()
