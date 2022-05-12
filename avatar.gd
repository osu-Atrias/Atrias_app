extends TextureRect

func _ready():
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", self, "_http_request_completed")

	var err = http_request.request("http://a.atrias.moe:12263/1")
	if err != OK:
		print("Error occurred in the HTTP request.")

func _http_request_completed(result, response_code, headers, body):
	var image = Image.new()
	var err = image.load_png_from_buffer(body)
	if err != OK:
		print("Error occurred while load image.")

	var texture = ImageTexture.new()
	texture.create_from_image(image)

	$".".texture = texture
	var _player: AnimationPlayer = get_parent().get_node("AnimationPlayer").play()
