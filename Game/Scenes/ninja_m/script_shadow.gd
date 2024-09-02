extends Node

var service_time = ServiceTime.new()
var coltdown_shadow_staying = 4.0
var MULTIPSYNC
# Called when the node enters the scene tree for the first time.
func _ready():
	MULTIPSYNC = get_parent().get_parent().get_node('MultiplayerSynchronizer')
	
	MULTIPSYNC.replication_config.add_property("animations/" + name + ":global_position")
	MULTIPSYNC.replication_config.add_property("animations/" + name + ":modulate")
	MULTIPSYNC.replication_config.add_property("animations/" + name + ":visible")
	
	self.modulate.a = 0
	var expire_shadow = service_time.init_timer(self, coltdown_shadow_staying)
	expire_shadow.timeout.connect(expire)
	expire_shadow.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.modulate.a < 1:
		self.modulate.a += 0.1
		await get_tree().create_timer(0.05).timeout

func expire():
	MULTIPSYNC.replication_config.remove_property("animations/" + name + ":global_position")
	MULTIPSYNC.replication_config.remove_property("animations/" + name + ":modulate")
	MULTIPSYNC.replication_config.remove_property("animations/" + name + ":visible")
	self.queue_free()
