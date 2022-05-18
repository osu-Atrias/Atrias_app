extends Control

onready var Noti = $Notification/AnimationPlayer
onready var NotiText = $Notification/up/Label
onready var StatText = $InfoTab/Label
onready var ProgressAnimation = $CheckList/AnimationPlayer
onready var bancho_url = "http://c4." + $Head/Host.text + ":" + $Head/Port.text
onready var api_url = "http://api." + $Head/Host.text + ":" + $Head/Port.text
onready var db_manager = preload("Lib.gdns").new()

var has_self_cfg = false
var has_atrias_client = false
var has_cfg_file = false
var has_db_file = false
var has_songs_path = false
var self_config: Config

var need_expand = false

func _ready():
	pre_ensure() # 检查是否已经存在 atrias 客户端，以及自身配置文件
	get_launcher_cfg()
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
	if !self_config.cfg_path.empty():
		has_cfg_file = true

func ensure_songs_path():
	yield(get_tree().create_timer(1.6), "timeout")
	StatText.text = "Checking Songs folder"
	if !self_config.songs_path.empty():
		has_songs_path = true

func ensure_osu_db():
	yield(get_tree().create_timer(1.8), "timeout")
	StatText.text = "Checking database"
	if !self_config.db_path.empty():
		if db_manager.ensure_db_structure(self_config.db_path):
			has_db_file = true
	
func init_complete():
	yield(get_tree().create_timer(2.2), "timeout")
	if self_config.osu_path == "" or !has_db_file or !has_songs_path:
		expand_wizard()
	else:
		$CheckList/EnsureFiles.text = "配置完整"
		
	if !has_atrias_client:
		$CheckList/Client.text = "未检测到Atrias客户端"
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
				has_self_cfg = true
			file_name = dir.get_next()
	else:
		pop_notification("检查客户端文件失败")
	
	if !has_self_cfg:
		init_cfg_file()
		

func _on_AnimationPlayer_animation_finished(anim_name):
	 pass
	 

func _on_SplashController_animation_finished(anim_name):
	pass

func _on_back_gui_input(event: InputEventMouse):
	if event.button_mask == 1:
		$Tranform/AnimationPlayer.play("transform")

func expand_wizard():
	yield(get_tree().create_timer(1.0), "timeout")
	$CheckList/AnimationPlayer.play("Expand")
	$CheckList/EnsureFiles.text = "配置不完整"
		
		
func init_cfg_file():
	var f = File.new()
	f.open("./config.ini", File.WRITE)
	f.store_string("osu_path=\natrias_path=\ndb_path=\nskin_path=\nsongs_path=\ncfg_path=")
	f.close()


func get_launcher_cfg():
	var f = File.new()
	f.open("./config.ini", File.READ)
	self_config = Config.new()
	self_config.osu_path = f.get_line().split("=")[1]
	self_config.atrias_path = f.get_line().split("=")[1]
	self_config.db_path = f.get_line().split("=")[1]
	self_config.skin_path = f.get_line().split("=")[1]
	self_config.songs_path = f.get_line().split("=")[1]
	self_config.cfg_path = f.get_line().split("=")[1]
	f.close()
	
func save_config():
	var f = File.new()
	f.open("./config.ini", File.WRITE)
	
	f.store_line("osu_path=" + self_config.osu_path)
	f.store_line("atrias_path=" + self_config.atrias_path)
	f.store_line("db_path=" + self_config.db_path)
	f.store_line("skin_path=" + self_config.skin_path)
	f.store_line("songs_path=" + self_config.songs_path)
	f.store_line("cfg_path=" + self_config.cfg_path)
	f.close()
	

class Config:
	var osu_path: String
	var atrias_path: String
	var db_path: String
	var skin_path: String
	var songs_path: String
	var cfg_path: String


func _on_TextureButton_pressed():
	$CheckList/FileDialog.popup()



func _on_FileDialog_dir_selected(dir):
	var osu_dir = Directory.new()
	if osu_dir.open(dir) == OK:
		self_config.osu_path = dir
		osu_dir.list_dir_begin()
		var file_name = osu_dir.get_next()
		while file_name != "":
			if file_name == "Songs" and osu_dir.current_is_dir():
				self_config.songs_path = dir + "/Songs"
				
			if file_name == "Skins" and osu_dir.current_is_dir():
				self_config.skin_path = dir + "/Skins"

			if file_name == "osu!.db" and not osu_dir.current_is_dir():
				self_config.db_path = dir + "/osu!.db"

			if "osu!" in file_name and ".cfg" in file_name and file_name != "osu!.cfg" and not osu_dir.current_is_dir():
				self_config.cfg_path = dir + "/" + file_name

			file_name = osu_dir.get_next()
	print(self_config.db_path.empty())
	if self_config.db_path.empty():
		pop_notification("未找到osu!.db文件\n请重新选择osu文件夹")
		$CheckList/FileDialog.popup()
		return
		
	save_config()
	$CheckList/AnimationPlayer.play_backwards("Expand")
	$CheckList/EnsureFiles.text = "配置完整"
	pop_notification("已配置: \n" + self_config.songs_path + "\n" + self_config.db_path + "\n" + self_config.skin_path)













