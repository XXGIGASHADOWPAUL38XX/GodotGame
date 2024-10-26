class_name PlayerController

var json = JSON.new()
var database = Database.new()

func get_player(username):
	var url_function = '/players?username=eq.' + username
	var method = HTTPClient.METHOD_GET
	
	var value = await database.request_http(url_function, method)
	return value
	
func set_session_id(session_id):
	var url_function = '/rpc/set_session_id'
	var method = HTTPClient.METHOD_POST
	var data = json.stringify({
		"player_id": Server.current_dbplayer["id"],
		"new_session_id": session_id
	})
	
	var value = await database.request_http(url_function, method, data)
	#rpc vers le server, 
	return value
	
func get_player_by_sid(peer_id):
	var url_function = '/players?session_id=eq.' + str(peer_id)
	var method = HTTPClient.METHOD_GET
	
	var value = await database.request_http(url_function, method)
	return value[0] # NE MARCHERA PAS TANT QUE ON PEUT SE CONNECTER PLUSIEURS FOIS AU MEME COMPTE
	

func add_friend(player_to_add_name):
	var url_function = '/rpc/add_friend_if_exists'
	var method = HTTPClient.METHOD_POST
	var data = json.stringify({
		"player_to_add": player_to_add_name
	})
	
	var value = await database.request_http(url_function, method, data)
	return value
	
func get_friends(player_id):
	var url_function = '/rpc/get_friends_of_player'
	var method = HTTPClient.METHOD_POST
	var data = json.stringify({
		"entry_id": player_id
	})
	
	var value = await database.request_http(url_function, method, data)
	return value
	
func login(username, password):
	var player = await get_player(username)
	if player.size() == 0:
		return PlayerException.LoginException.USERNAME_INCORRECT
	player = player[0]
		
	if player["password"] != hash_password(password):
		return PlayerException.LoginException.PASSWORD_INCORRECT
		
	Server.current_dbplayer = player
	return player
		
func signup(username, password):
	var player = await get_player(username)
	
	if player.size() != 0:
		return PlayerException.SignupException.USERNAME_ALREADY_EXISTS
		
	var url_function = '/players'
	var method = HTTPClient.METHOD_POST
	
	var data = json.stringify({
		"username": username,
		"password": hash_password(password)
	})
	
	var value = await database.request_http(url_function, method, data)
	return player

func hash_password(password: String) -> String:
	var context = HashingContext.new()
	context.start(HashingContext.HASH_SHA256)
	context.update(password.to_utf8_buffer())
	var hash_result = context.finish()

	return hash_result.hex_encode()
