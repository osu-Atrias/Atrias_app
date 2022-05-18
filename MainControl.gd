extends Control

onready var Noti = $Notification/AnimationPlayer
onready var NotiText = $Notification/up/Label
onready var StatText = $InfoTab/Label
onready var ProgressAnimation = $CheckList/AnimationPlayer
onready var bancho_url = "http://c4." + $Head/Host.text + ":" + $Head/Port.text
onready var api_url = "http://api." + $Head/Host.text + ":" + $Head/Port.text

var has_launcher_cfg = false
var has_atrias_client = false
var has_cfg_file = false
var has_db_file = false
var self_config: Config

var need_expand = false

func _ready():
	pre_ensure() # 检查是否已经存在 atrias 客户端，以及自身配置文件
	get_launcher_cfg()
	perform_start()
	var api = preload("Lib.gdns")
	var manager = api.new()
	var a = manager.ensure_db_structure("aa")

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
	var http_req = HTTPRequest.new()
	add_child(http_req)	
	var err = http_req.request(bancho_url)
	if err != OK:
		pop_notification("服务器连接失败")
	else:
		pop_notification("已连接服务器")

func check_client_version():
	yield(get_tree().create_timer(1.2), "timeout")
	StatText.text = "Checking updates"
	var http_req = HTTPRequest.new()
	add_child(http_req)	
	var err = http_req.request(api_url + "/version")
	if err != OK:
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
	expand_wizard()
	yield(get_tree().create_timer(2.0), "timeout")
	StatText.text = "All completed"

func pop_notification(_str: String):
	NotiText.text = _str
	Noti.play("notification-pop")

func pre_ensure():
	var dir = Directory.new()
	if dir.open("./") == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name == "osu!.exe":
				has_atrias_client = true
			if file_name == "config.ini":
				has_launcher_cfg = true
			file_name = dir.get_next()
	else:
		pop_notification("检查客户端文件失败")
	
	if !has_launcher_cfg:
		var f = File.new()
		f.open("./config.ini", File.WRITE)
		f.store_string("osu_path=\natrias_path=")
		f.close()
		

func _on_AnimationPlayer_animation_finished(anim_name):
	 $CheckList/EnsureFiles.text = "客户端配置完整"
	 $CheckList/Client.text = "已是最新版本"

func _on_SplashController_animation_finished(anim_name):
	pass

func _on_back_gui_input(event: InputEventMouse):
	if event.button_mask == 1:
		$Tranform/AnimationPlayer.play("transform")

func expand_wizard():
	yield(get_tree().create_timer(1.0), "timeout")
	if self_config.osu_path == "":
		$CheckList/AnimationPlayer.play("Expand")
		
		

func get_launcher_cfg():
	var f = File.new()
	f.open("./config.ini", File.READ)
	self_config = Config.new()
	self_config.osu_path = f.get_line().split("=")[1]
	self_config.atrias_path = f.get_line().split("=")[1]

class Config:
	var osu_path: String
	var atrias_path: String


func _on_TextureButton_pressed():
	$CheckList/FileDialog.popup()



func _on_FileDialog_dir_selected(dir):
	var songs_path = ""
	var skins_path = ""
	var db_path = ""
	var cfg_path = ""
	
	var osu_dir = Directory.new()
	if osu_dir.open(dir) == OK:
		osu_dir.list_dir_begin()
		var file_name = osu_dir.get_next()
		while file_name != "":
			if file_name == "Songs" and osu_dir.current_is_dir():
				songs_path = dir + "/Songs"
				
			if file_name == "Skins" and osu_dir.current_is_dir():
				skins_path = dir + "/Skins"

			if file_name == "osu!.db" and not osu_dir.current_is_dir():
				db_path = dir + "/osu!.db"

			if "osu!" in file_name and ".cfg" in file_name and file_name != "osu!.cfg" and not osu_dir.current_is_dir():
				cfg_path = dir + "/" + file_name

			file_name = osu_dir.get_next()

	print("cfg: " + cfg_path)
	print("db: " + db_path)
	print("skins: " + skins_path)
	print("songs: " + songs_path)












