extends Node2D

var duplicator

var mark
var sphere_regen

# Called when the node enters the scene tree for the first time.
func _ready():
	duplicator = self.get_parent()
	mark = $mark
	sphere_regen = $sphere_regen

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func post_dp_script(id, nbr_dupl):
	var key_ennemy_marked = duplicator.ennemies_sorted()[id - 1]
	mark.key_ennemy_marked = key_ennemy_marked
