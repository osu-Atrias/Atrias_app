extends Node2D

onready var _control = $MainControl

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _on_SplashController_animation_finished(anim_name):
	_control.visible = 1
	
