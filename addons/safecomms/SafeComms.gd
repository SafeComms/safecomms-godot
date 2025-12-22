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
func moderate_text(text: String, language: String = "en", replace: bool = false, pii: bool = false, replace_severity: String = "", moderation_profile_id: String = "") -> Dictionary:
	if api_key.is_empty():
		push_error("SafeComms: API Key is not set.")
		return {"error": "API Key not set"}

	var url = base_url + "/moderation/text"
	var headers = [
		"Content-Type: application/json",
		"Authorization: Bearer " + api_key
	]
	
	var payload = {
		"content": text,
		"language": language,
		"replace": replace,
		"pii": pii
	}
	
	if not replace_severity.is_empty():
		payload["replaceSeverity"] = replace_severity
		
	if not moderation_profile_id.is_empty():
		payload["moderationProfileId"] = moderation_profile_id
	
	var body = JSON.stringify(payload)

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

## Moderate an image (URL or Base64).
## Returns a Dictionary with the moderation result.
func moderate_image(image: String, language: String = "en", moderation_profile_id: String = "", enable_ocr: bool = false, enhanced_ocr: bool = false, extract_metadata: bool = false) -> Dictionary:
	if api_key.is_empty():
		push_error("SafeComms: API Key is not set.")
		return {"error": "API Key not set"}

	var url = base_url + "/moderation/image"
	var headers = [
		"Content-Type: application/json",
		"Authorization: Bearer " + api_key
	]
	
	var payload = {
		"image": image,
		"language": language,
		"enableOcr": enable_ocr,
		"enhancedOcr": enhanced_ocr,
		"extractMetadata": extract_metadata
	}
	
	if not moderation_profile_id.is_empty():
		payload["moderationProfileId"] = moderation_profile_id
		
	var body = JSON.stringify(payload)

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

## Moderate an image file from disk.
## Returns a Dictionary with the moderation result.
func moderate_image_file(path: String, language: String = "en", moderation_profile_id: String = "") -> Dictionary:
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("SafeComms: Failed to open file: " + path)
		return {"error": "Failed to open file"}
	
	var bytes = file.get_buffer(file.get_length())
	var base64 = Marshalls.raw_to_base64(bytes)
	var extension = path.get_extension().to_lower()
	var mime = "image/jpeg"
	if extension == "png":
		mime = "image/png"
	elif extension == "webp":
		mime = "image/webp"
	elif extension == "gif":
		mime = "image/gif"
		
	var data_uri = "data:" + mime + ";base64," + base64
	return await moderate_image(data_uri, language, moderation_profile_id)
