extends PanelContainer

var resource_awaiter = ResourceAwaiter.new()

var champion: HerosDescription
var duplicator

@onready var champion_vbox = $MarginContainer/champion_vbox
@onready var name_label = $MarginContainer/champion_vbox/HBoxContainer/Label
@onready var is_ready = true

var stats_hboxs

var stat_color_mapping = {
	"damage": Color(1, 0.2, 0.2, 0.6),
	"resistance": Color(0.7, 1, 0.3, 0.6),
	"mobility": Color(1, 1, 0.5, 0.6),
	"utility": Color(0.5, 0.5, 1, 0.6),
	"controls": Color(0.7, 0.3, 0, 0.6),
	"difficulty": Color(0.4, 0.4, 0.4, 0.6)
}

# Called when the node enters the scene tree for the first time.
func _ready():
	self.add_theme_stylebox_override("panel", self.get_theme_stylebox("panel").duplicate())
	
	stats_hboxs = champion_vbox.get_children().filter(func(child): 
		return child is HBoxContainer && child.has_node("margin/stats_bars")
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func post_dp_script(id, dp_number):
	ServiceScenes.loading_async.add_loading(self.name, "Chargement des stats des champions")
	duplicator = self.get_parent().get_node("dp_champion_box")
	champion = duplicator.all_heros[id - 1]
	
	await resource_awaiter.await_resource_loaded(func(): return is_ready)
	display()

func display():
	self.get_theme_stylebox("panel", "PanelContainer").texture = load("res://Game/Ressources/UI/Champions/" + champion.name + ".png")
	name_label.text = champion.name

	stats_hboxs.map(func(stat_hbox):
		var stats_bars = stat_hbox.get_node("margin/stats_bars")
		var stat = champion.get(stat_hbox.name)
		
		for i in range(4):
			var style_box = StyleBoxFlat.new()
			style_box.bg_color = stat_color_mapping[stat_hbox.name] if stat > i else Color(0.4, 0.4, 0.4, 0.3)
			self.self_modulate = Color(0.6, 0.6, 0.6, 0.4)
			
			var panel = Panel.new()
			panel.add_theme_stylebox_override("panel", style_box)
			panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			panel.add_theme_constant_override("corner_radius_top_left", 5)
			panel.add_theme_constant_override("corner_radius_top_right", 5)
			panel.add_theme_constant_override("corner_radius_bottom_left", 5)
			panel.add_theme_constant_override("corner_radius_bottom_right", 5)
			
			stats_bars.add_child(panel)
			
			if stat_hbox == stats_hboxs[stats_hboxs.size() - 1] && i == 3:
				ServiceScenes.loading_async.remove_loading(self.name)
	)
