extends TextureRect

onready var _player = get_parent().get_node("AnimationPlayer")

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_back_mouse_entered():
	_player.play("MouseHoverBack")


func _on_back_mouse_exited():
	_player.play("MouseExitBack")
