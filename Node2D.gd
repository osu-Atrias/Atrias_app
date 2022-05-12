extends Node2D


onready var avatar = $avatar


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func download_avatar():
	var req = HTTPRequest.new()
	avatar.texture.se
	req.set_display_folded()
