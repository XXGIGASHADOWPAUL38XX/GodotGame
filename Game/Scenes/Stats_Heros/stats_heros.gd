extends Control

var champion
var champion_health
var camera
var health_bar
var spells

var CONST_STATS = ['damage_final', 'armor_final', 'health_final', 'speed_final']

# Called when the node enters the scene tree for the first time.
func _ready():
	champion = ServiceScenes.championNode
	camera = ServiceScenes.getCamera()
	champion_health = champion.get_node("health_bar")
	
	spells = $Panel/HBoxContainer/HUD/HBoxContainer
	
	health_bar = $Panel/HBoxContainer/HUD/Header/MarginContainer/ProgressBar
	health_bar.max_value = champion_health.max_value
	health_bar.value = champion_health.max_value
	
	$Panel/HBoxContainer/HUD/Header/TextureRect.texture = load("res://Game/Ressources/Heros/icons/" 
	+ ServiceScenes.champion.name + ".png")

	get_texture_spells()
	get_stats()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	health_bar.value = champion_health.value
	
	self.position = Vector2(camera.offset.x, camera.offset.y + ((get_window().size.y - $Panel.size.y) / 2))
	
func get_stats():
	for stat in CONST_STATS:
		var label_stat = Label.new()
		label_stat.add_theme_font_size_override('font_size', 12)
		label_stat.add_theme_color_override('font_color', Color.WHITE)
		label_stat.set_name(stat)
		label_stat.text = stat.to_upper() + ' : ' + str(int(champion.get(stat))) 
		$Panel/HBoxContainer/Stats.add_child(label_stat)

func update_stats_local():
	var label_modified = $Panel/HBoxContainer/Stats.get_children().filter(func(label):
		return label.text.substr(label.text.find(":") + 2) != str(
			champion.get(label.get_name())
		)
	)
	
	for label in label_modified:
		label.text = label.get_name().to_upper() + ' : ' + str(champion.get(label.get_name()))

func bindTo(coltdown, spell_number:int):
	var spell = spells.get_child(spell_number - 1).get_node('TPB')
	spell.value = (coltdown.wait_time - coltdown.time_left) / coltdown.wait_time * 100

func get_texture_spells():
	var spells_icons = $Panel/HBoxContainer/HUD/HBoxContainer
	for i in range(1, spells_icons.get_children().size() + 1):
		var progressBar = spells_icons.get_child(i - 1).get_node('TPB') as ProgressBar
		var styleBox = StyleBoxTexture.new()
		
		var texture = load('res://Game/Ressources/Heros/icons_spells/spell_' + ServiceScenes.champion.name 
			+ '_' + str(i) + '.png')
		styleBox.texture = texture 
		
		progressBar.add_theme_stylebox_override('background', styleBox) 
		
