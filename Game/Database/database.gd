class_name Database

const URL_API = "https://zuyprriovxsmbbeppnyh.supabase.co/rest/v1"
const API_KEY = "apikey:eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inp1eXBycmlvdnhzbWJiZXBwbnloIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzA0NzQ3NTQsImV4cCI6MjA4NjA1MDc1NH0.byJ47sTTQnxwXhx0o8mW0KzjmZyeaaqqI6mXPWJi5kg" 
const AUTHORISATION_KEY = "Authorization:Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inp1eXBycmlvdnhzbWJiZXBwbnloIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3MDQ3NDc1NCwiZXhwIjoyMDg2MDUwNzU0fQ.ErYWBd-qwTUkgMalGYZK2sCbKLgxhejJl0nOkWYG4dY"

signal value_emitted

var http_request: HTTPRequest

var resource_awaiter = ResourceAwaiter.new()

func request_http(url, method, data="", headers=PackedStringArray([API_KEY, AUTHORISATION_KEY])):
	ServiceScenes.loading_async.add_loading(url, "Requête vers la base de données")
	var value = {}
	
	http_request = HTTPRequest.new()
	Server.add_child(http_request)
	http_request.request_completed.connect(
		func(result, response_code, headers, body):
			value["data"] = self._http_request_completed.call(result, response_code, headers, body)
			value_emitted.emit()
			ServiceScenes.loading_async.remove_loading(url)
	)
	
	var error = http_request.request(URL_API + url, headers, method, data)
	
	if error != OK:
		print("An error occurred: ", error)
		
	await value_emitted
	
	return value["data"] if value.keys().size() != 0 else null

func _http_request_completed(result, response_code, headers, body):
	#print(headers, "\n", body.get_string_from_utf8(), "\n", response_code)
	if str(response_code)[0] == str(2):
		var json_instance = JSON.new()
		var response_text = body.get_string_from_utf8()
		
		var error = json_instance.parse(response_text)
		
		if error == OK:
			return json_instance.data
			print("Response JSON: ", json_instance.data)
		else:
			print("Failed to parse JSON")
	else:
		print("Request failed with response code: ", response_code)
