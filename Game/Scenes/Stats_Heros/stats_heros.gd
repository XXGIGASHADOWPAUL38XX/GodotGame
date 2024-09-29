extends Control

var champion
var champion_health
var camera

@onready var stats = $VBoxContainer/Panel/MarginContainer/HBoxContainer/Stats
@onready var spells = $VBoxContainer/Panel/MarginContainer/HBoxContainer/HUD/spells_hud
@onready var health_bar = $VBoxContainer/Panel/MarginContainer/HBoxContainer/HUD/MarginContainer/Header/health_bar
@onready var champion_profile = $VBoxContainer/Panel/MarginContainer/HBoxContainer/HUD/MarginContainer/Header/champion_profile
@onready var item_grid = $VBoxContainer/Panel/MarginContainer/HBoxContainer/Stats_Items/Items

var CONST_STATS = ['damage_final', 'armor_final', 'health_final', 'speed_final']

var mapping_key_hud = {
	ServiceSettings.keys_values['key_spell_1']: 0,
	ServiceSettings.keys_values['key_spell_2']: 1,
	ServiceSettings.keys_values['key_spell_3']: 2,
	ServiceSettings.keys_values['key_special']: 3,
	ServiceSettings.keys_values['key_ultimate']: 4,
	ServiceSettings.keys_values['key_active_boss']: 5,
	ServiceSettings.keys_values['key_active_item']: 6
}

var item_plhdr_base_texture = preload('res://Game/Ressources/UI/HUD/item_bg.png')

var mapping_texture_items = {
	'armor_gem': preload('res://Game/Ressources/Gems/armor_gem.png'),
	'attack_gem': preload('res://Game/Ressources/Gems/attack_gem.png'),
	'block_gem': preload('res://Game/Ressources/Gems/block_gem.png'),
	'boost_gem': preload('res://Game/Ressources/Gems/boost_gem.png'),
	'cleanse_gem': preload('res://Game/Ressources/Gems/cleanse_gem.png'),
	'drone_gem': preload('res://Game/Ressources/Gems/drone_gem.png'),
	'earthquake_gem': preload('res://Game/Ressources/Gems/earthquake_gem.png'),
	'health_gem': preload('res://Game/Ressources/Gems/health_gem.png'),
	'mark_gem': preload('res://Game/Ressources/Gems/mark_gem.png'),
	'shockwave_gem': preload('res://Game/Ressources/Gems/shockwave_gem.png'),
	'slash_gem': preload('res://Game/Ressources/Gems/slash_gem.png'),
	'speed_gem': preload('res://Game/Ressources/Gems/speed_gem.png')
}

# Called when the node enters the scene tree for the first time.
func _ready():
	ServiceScenes.HUD = self
	champion = ServiceScenes.championNode
	camera = ServiceScenes.camera
	champion_health = champion.health_bar
	
	health_bar.max_value = champion_health.max_value
	health_bar.value = champion_health.max_value
	
	champion_profile.texture = load("res://Game/Ressources/Heros/hud_icons/" 
	+ ServiceScenes.champion.name + ".png")

	get_texture_spells()
	get_stats()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	health_bar.value = champion_health.value
	self.position = camera.offset
	
func get_stats():
	for stat in CONST_STATS:
		if stats.get_children().size() < CONST_STATS.size():
			var label_stat = Label.new()
			label_stat.size_flags_vertical = Control.SIZE_EXPAND_FILL
			label_stat.add_theme_font_size_override('font_size', 15)
			label_stat.add_theme_color_override('font_color', Color.GRAY)
			label_stat.set_name(stat)
			stats.add_child(label_stat)
		
		stats.get_node(stat).text = stat.to_upper() + ' : ' + str(int(champion.get(stat))) 

func display_stats():
	var label_modified = stats.get_children().filter(func(label):
		return label.text.substr(label.text.find(":") + 2) != str(
			champion.get(label.get_name())
		)
	)
	
	for label in label_modified:
		label.text = label.get_name().to_upper() + ' : ' + str(champion.get(label.get_name()))

func bind_to(coltdown, key_value:int):
	if not mapping_key_hud.has(key_value):
		return
	
	var spell = spells.get_child(mapping_key_hud[key_value])
	spell.value = coltdown.time_left / coltdown.wait_time * 100

func get_texture_spells():
	for i in range(spells.get_children().size() - 2):
		var progressBar = spells.get_child(i) as ProgressBar
		var styleBox = StyleBoxTexture.new()
		
		var texture = load('res://Game/Ressources/Heros/hud_icons_spells/' + ServiceScenes.champion.name 
			+ '/' + str(i) + '.png')
		styleBox.texture = texture 
		
		progressBar.add_theme_stylebox_override('background', styleBox) 
		
func update_items(orb_dict):
	item_grid.get_children().map(func(item_plhdr): 
		item_plhdr.get_theme_stylebox('panel', 'PanelContainer').texture = item_plhdr_base_texture
		item_plhdr.get_node("Label").text = ""
	)
	
	var local_dict = orb_dict.duplicate()
	local_dict.keys().map(func(orb_key):
		var item_plhdr = item_grid.get_child(local_dict.keys().find(orb_key))
		
		item_plhdr.get_theme_stylebox('panel', 'PanelContainer').texture = mapping_texture_items[orb_key]
		item_plhdr.get_node("Label").text = str(local_dict[orb_key])
	)
	
