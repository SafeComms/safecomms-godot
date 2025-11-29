extends Node

## SafeComms Godot SDK
##
## A simple wrapper for the SafeComms Content Moderation API.
## Usage:
## var result = await SafeComms.moderate_text("some text")
## if result.flagged:
##     print("Text was flagged!")

# Configuration
var api_key: String = ""
var base_url: String = "https://api.safecomms.dev"

# Internal HTTP Request node
var _http: HTTPRequest

func _ready():
	_http = HTTPRequest.new()
	add_child(_http)

## Moderate a text string.
## Returns a Dictionary with the moderation result.
func moderate_text(text: String) -> Dictionary:
	if api_key.is_empty():
		push_error("SafeComms: API Key is not set.")
		return {"error": "API Key not set"}

	var url = base_url + "/moderation/text"
	var headers = [
		"Content-Type: application/json",
		"Authorization: Bearer " + api_key
	]
	var body = JSON.stringify({
		"content": text
	})

	# Perform the request
	var error = _http.request(url, headers, HTTPClient.METHOD_POST, body)
	if error != OK:
		push_error("SafeComms: HTTP Request failed to start.")
		return {"error": "Request failed"}

	# Wait for response
	var response = await _http.request_completed
	var result_body = response[3]
	var json = JSON.new()
	json.parse(result_body.get_string_from_utf8())
	
	return json.get_data()
