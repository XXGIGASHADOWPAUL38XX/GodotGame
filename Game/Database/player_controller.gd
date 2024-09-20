class_name PlayerController

var json = JSON.new()

func get_player(username):
	var url_function = '/players?username=eq.' + username
	var method = HTTPClient.METHOD_GET
	
	var value = await Database.request_http(url_function, method)
	return value
	
func get_friends(player_id):
	var url_function = '/rpc/get_friends_of_player'
	var method = HTTPClient.METHOD_POST
	var data = json.stringify({
		"entry_id": player_id
	})
	
	var value = await Database.request_http(url_function, method, data)
	return value
	
func login(username, password):
	var player = await get_player(username)
	if player.size() == 0:
		return PlayerException.LoginException.USERNAME_INCORRECT
	player = player[0]
		
	if player["password"] != hash_password(password):
		return PlayerException.LoginException.PASSWORD_INCORRECT
		
	Server.current_playerpeer = player
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
	
	var value = await Database.request_http(url_function, method, data)
	return player

func hash_password(password: String) -> String:
	var context = HashingContext.new()
	context.start(HashingContext.HASH_SHA256)
	context.update(password.to_utf8_buffer())
	var hash_result = context.finish()

	return hash_result.hex_encode()
