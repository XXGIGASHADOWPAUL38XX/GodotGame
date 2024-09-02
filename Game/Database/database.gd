extends Node

const URL_API = "https://bothjybvzeurkxhcbmsk.supabase.co/rest/v1"
const API_KEY = "apikey:eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJvdGhqeWJ2emV1cmt4aGNibXNrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjQ4ODAzNTgsImV4cCI6MjA0MDQ1NjM1OH0.fqNwtzE8JPsvLXCCkRxHIINjxBZlgX0oP-QnXLXN4rk" 
const AUTHORISATION_KEY = "Authorization:Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJvdGhqeWJ2emV1cmt4aGNibXNrIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTcyNDg4MDM1OCwiZXhwIjoyMDQwNDU2MzU4fQ.NaUkVWcVrA6GOrCvAsyMlajnFdyYSbH6dx0vaCtmgRw"

signal value_emitted

var http_request: HTTPRequest

var resource_awaiter = ResourceAwaiter.new()

func request_http(url, method, data="", headers=PackedStringArray([API_KEY, AUTHORISATION_KEY])):
	ServiceScenes.loading_async.add_loading(self.name, "Requête vers la base de données")
	var value = {}
	
	http_request = HTTPRequest.new()
	self.add_child(http_request)
	http_request.request_completed.connect(
		func(result, response_code, headers, body):
			value["data"] = self._http_request_completed.call(result, response_code, headers, body)
			value_emitted.emit()
			ServiceScenes.loading_async.remove_loading(self.name)
	)
	
	var error = http_request.request(URL_API + url, headers, method, data)
	
	if error != OK:
		print("An error occurred: ", error)
		
	await value_emitted
	
	return(value["data"])

func _http_request_completed(result, response_code, headers, body, test="sss"):
	if response_code == 200:
		var response_text = body.get_string_from_utf8()
		
		var json_instance = JSON.new()
		var error = json_instance.parse(response_text)
		
		if error == OK:
			return json_instance.data
			print("Response JSON: ", json_instance.data)
		else:
			print("Failed to parse JSON")
	else:
		print("Request failed with response code: ", response_code)
