extends Node2D

var team_client: int = 0
var team_server: int = 0
var player_client: int = 0
var player_server: int = 0

const SELECTION_TIME = 10
const START_GAME_WAIT_TIME = 3

var service_time = preload("res://Game/Services/service_time.gd").new()
var player_class = preload("res://Game/Classes/Players/Player.gd")
var players = [] 

var time_label = Timer.new()

func _ready():
	for champion in $Champions.get_children():
		champion.mouse_entered.connect(_button_hovered.bind(champion))
		champion.mouse_exited.connect(_button_unhovered.bind(champion))
		champion.pressed.connect(_button_pressed.bind(champion))
		
	team_client = id_client_to_team_client()
	player_client = id_client_to_player_client()
	
	team_server = 1
	player_server = 1
	
	$announcer_progress.set_announce('PICK PHASE - PLAYER ' + str(team_server) + ' : ', 10)

func _button_hovered(button_champion):
	button_champion.self_modulate = Color.GRAY

func _button_unhovered(button_champion):
	button_champion.self_modulate = Color.WHITE

func _button_pressed(champion):
	if champion.get_name() == 'random':
		lock_random_champion()
	else:
		lock_champion(champion)
	
func _process(_delta):	
	if (team_server == team_client && player_server == player_client):
		$Champions.show()
	else:
		$Champions.hide()


func lock_random_champion():
	var available_champions = $Champions.get_children().filter(
		func (champ):
			return champ.modulate != Color.DARK_GRAY
	)
	
	lock_champion(available_champions[randf_range(0, available_champions.size() - 1)])

func lock_champion(champion):
	Servrpc.any(self, 'display_champion', [champion.name, team_client, player_client])
	Servrpc.any(self, 'set_player', [Server.get_actual_player(), champion.name, team_client])
	
	if player_server > ServiceScenes.CONFIG_NB_PLAYERS_GAME / 2:
		Servrpc.any($announcer_progress, 'set_announce', ['GAME STARTING IN : ', START_GAME_WAIT_TIME])
	else:
		Servrpc.any($announcer_progress, 'set_announce', ['PICK PHASE - PLAYER ' + str(team_server) + ' : ', SELECTION_TIME])
		
func _on_announcer_anncounce_timeout():
	if player_server > ServiceScenes.CONFIG_NB_PLAYERS_GAME / 2:
		launch_game()
#	else:
#		lock_random_champion()

func display_champion(champion_name, team_client_sender, player_client_sender):
	var display_box = get_node('Team_' + str(team_client_sender)).get_node('Player_' + str(player_client_sender))
	display_box.texture = load('res://Game/Ressources/Heros/icons_champ_select/' + champion_name + '.png')
	display_box.self_modulate.a = 0.5
	display_box.self_modulate = Color.WHITE
	
	var picked_champion = $Champions.get_node(champion_name as NodePath)
	if (picked_champion.modulate != Color.DARK_GRAY):
		picked_champion.modulate = Color.DARK_GRAY
		picked_champion.pressed.disconnect(_button_pressed)
		
	if team_client_sender == 2:
		player_server += 1
	
	team_server = [null, 2, 1].find(team_server)

func launch_game():
	ServiceScenes.set_players(players)
	get_tree().change_scene_to_file("res://Game/Scenes/Main/main_game.tscn")

func set_player(id_player, champion_name, team_client_sender):
	players.append(player_class.Player.new(id_player, champion_name, team_client_sender == team_client))
	
func id_client_to_team_client():
	return [1, 2, 1, 2][Server.get_connected_clients().find(Server.get_actual_player())]

func id_client_to_player_client():
	return [1, 1, 2, 2][Server.get_connected_clients().find(Server.get_actual_player())]
