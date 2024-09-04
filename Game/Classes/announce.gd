class_name Announce

var text: String
var logo_left: String
var logo_right: String
var champion

func _init(text: String, logo_left: String, logo_right: String, champion=null) -> void:
	self.text = text
	self.logo_left = logo_left
	self.logo_right = logo_right
	self.champion = champion

enum AnnounceKind {
	NULL,
	ALLY,
	ENNEMY
}
