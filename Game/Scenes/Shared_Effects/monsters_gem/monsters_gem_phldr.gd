extends IPlaceholderSpells

var gem_dropped

# Called when the node enters the scene tree for the first time.
func _ready():
	gem_dropped = $objects/gem_dropped
	await super._ready()
