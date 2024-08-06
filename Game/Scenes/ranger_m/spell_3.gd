extends Node2D

var target
var mark_explode
var bubble

# Called when the node enters the scene tree for the first time.
func _ready():
	target = $target/target
	mark_explode = $mark_explode/mark_explode
	bubble = $bubble/spells_3_bubbles

func active():
	#var thread_1 = Thread.new()
	#var thread_2 = Thread.new()
	
	for i in range(target.animation.frame):
		mark_explode.active(target.position)
		bubble.active(target.position)
		
		#thread_1.start(Callable(mark_explode, 'active').bind(target.position))
		#thread_2.start(Callable(bubble, 'active').bind(target.position))
		target.animation.frame -= 1
		# mines_count.frame += 1
		
		await get_tree().create_timer(0.2).timeout
		
		#thread_1.wait_to_finish()
		#thread_2.wait_to_finish()

func post_dp_script(id):
	target.key_ennemy_marked = ennemies_of_current()[id - 1]
	bubble.key_ennemy_marked = ennemies_of_current()[id - 1]

func ennemies_of_current():
	return ServiceScenes.ennemiesNode if is_multiplayer_authority() else ServiceScenes.alliesNode
