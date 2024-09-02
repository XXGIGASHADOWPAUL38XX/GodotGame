extends Control

@onready var label = $VBoxContainer/PanelContainer/Label
@onready var bars = [$VBoxContainer/TopBar, $VBoxContainer/BottomBar]

var service_time = ServiceTime.new()
var duration_timer: Timer

const ALPHA_COLOR_BAR = 0.6

var bars_color_mapper = {
	AnnounceUI.AnnounceKind.NULL: Color(ALPHA_COLOR_BAR, ALPHA_COLOR_BAR, ALPHA_COLOR_BAR),
	AnnounceUI.AnnounceKind.ERROR: Color(ALPHA_COLOR_BAR, 0, 0),
	AnnounceUI.AnnounceKind.WARNING: Color(ALPHA_COLOR_BAR, ALPHA_COLOR_BAR, 0),
	AnnounceUI.AnnounceKind.SUCCESS: Color(0, ALPHA_COLOR_BAR, 0),
}

# Called when the node enters the scene tree for the first time.
func _ready():
	ServiceScenes.announcer_ui = self
	self.modulate.a = 0
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func announce(announce_text, announce_kind=AnnounceUI.AnnounceKind.NULL, announce_duration=1.2):
	bars.map(func(bar): 
		var stylebox_texture = bar.get_theme_stylebox('panel', 'Panel').texture
		stylebox_texture.gradient.set_color(0, Color(bars_color_mapper[announce_kind], 0))
		stylebox_texture.gradient.set_color(1, Color(bars_color_mapper[announce_kind], ALPHA_COLOR_BAR))
		stylebox_texture.gradient.set_color(2, Color(bars_color_mapper[announce_kind], 0))
	)
	
	label.text = announce_text
	duration_timer = service_time.init_timer(self, announce_duration)
	duration_timer.timeout.connect(func():
		for i in range(10):
			self.modulate.a -= 0.1
			await get_tree().create_timer(0).timeout
			
		self.hide()
	)
	duration_timer.start()
	
	self.show()
	for i in range(10):
		self.modulate.a += 0.1
		await get_tree().create_timer(0).timeout
	
	
