extends Control

onready var Noti = $Notification/AnimationPlayer
onready var NotiText = $Notification/up/Label
onready var StatText = $InfoTab/Label
onready var ProgressAnimation = $CheckList/AnimationPlayer
onready var bancho_url = "http://c4." + $Host.text + ":" + $Port.text
onready var api_url = "http://api." + $Host.text + ":" + $Port.text
var http_req: HTTPRequest

func _ready():
	http_req = HTTPRequest.new()
	add_child(http_req)
	perform_start()

func perform_start():
	yield(get_tree().create_timer(2.0), "timeout")
	check_server_connection()
	check_client_version()
	ProgressAnimation.play("fake_progress1s1")
	ensure_cfg()
	ensure_osu_db()
	ensure_songs_path()
	init_complete()

func check_server_connection():
	yield(get_tree().create_timer(1.0), "timeout")
	StatText.text = "Connecting Server"
	var err = http_req.request(bancho_url)
	if err != OK:
		pop_notification("服务器连接失败")
	else:
		pop_notification("已连接服务器")

func check_client_version():
	yield(get_tree().create_timer(1.2), "timeout")
	StatText.text = "Checking updates"
	if http_req.request(api_url + "/version") != OK:
		pop_notification("Version check failed")

		
	

func ensure_cfg():
	yield(get_tree().create_timer(1.4), "timeout")
	StatText.text = "Checking osu config"

func ensure_songs_path():
	yield(get_tree().create_timer(1.6), "timeout")
	StatText.text = "Checking Songs folder"

func ensure_osu_db():
	yield(get_tree().create_timer(1.8), "timeout")
	StatText.text = "Checking database"
	
func init_complete():
	yield(get_tree().create_timer(2.0), "timeout")
	StatText.text = "All completed"

func pop_notification(_str: String):
	NotiText.text = _str
	Noti.play("notification-pop")


func _on_AnimationPlayer_animation_finished(anim_name):
	 NotiText.text = ""
	 $CheckList/EnsureFiles.text = "客户端配置完整"
	 $CheckList/Client.text = "已是最新版本"


func _on_SplashController_animation_finished(anim_name):
	pass

func _wait(s:float):
	yield(get_tree().create_timer(s), "timeout")


func _on_back_gui_input(event: InputEventMouse):
	if event.button_mask == 1:
		OS.execute("D://osu-atri/osu-atrias/osu!win/bin/PublicNoUpdate/osu!.exe", [], false)
