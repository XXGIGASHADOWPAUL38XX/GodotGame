extends Control

const SCENE_WIDTH = 2400
const SCENE_HEIGHT = 1360

var camera
var ratio 

# Called when the node enters the scene tree for the first time.
func _ready():
	ratio = $TextureRect.custom_minimum_size.x / SCENE_WIDTH
	camera = ServiceScenes.getCamera()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$TextureRect.position = Vector2(
		camera.offset.x + (get_window().size.x / 2) - $TextureRect.size.x,
		camera.offset.y - (get_window().size.y / 2)
	)

	assign_points()
		
func assign_points():
	for i in range(ServiceScenes.alliesNode.size()):
		$TextureRect/Allies.get_child(i).position = ServiceScenes.alliesNode[i].position * ratio
	for i in range(ServiceScenes.ennemiesNode.size()):
		$TextureRect/Ennemies.get_child(i).position = ServiceScenes.ennemiesNode[i].position * ratio
