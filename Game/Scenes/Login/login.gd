extends Control

const MENU_SCENE_PATH = "res://Game/Scenes/Menu/menu_scene.tscn"

var submit_type = login_signup.LOGIN
var player_controller = PlayerController.new()

enum login_signup {
	LOGIN,
	SIGNUP,
}

@onready var constraints_login_node = $HBoxContainer/MarginContainer/Main/Constraints_Login
@onready var constraints_signup_node = $HBoxContainer/MarginContainer/Main/Constraints_Signup
var constraints_node

@onready var validate = $HBoxContainer/MarginContainer/Main/Validate

@onready var form = {
	'username': $HBoxContainer/MarginContainer/Main/Username/LineEdit,
	'password': $HBoxContainer/MarginContainer/Main/Password/LineEdit,
	'password_confirm': $HBoxContainer/MarginContainer/Main/PasswordConfirm/LineEdit,
}

var constraints_login = {
	'FieldsRequired': Callable(self, 'fields_required'),
}

var constraints_signup = {
	'LengthGt7': Callable(self, 'length_gt_7'),
	'SpecialCharacter': Callable(self, 'contains_special_char'),
	'Number': Callable(self, 'contains_number'),
	'LowerUpper': Callable(self, 'contains_lower_upper'),
	'PasswordsSimilar': Callable(self, 'passwords_similar')
}

@onready var login_signup_choice = $HBoxContainer/MarginContainer/Main/LoginSignupChoice

# Called when the node enters the scene tree for the first time.
func _ready():
	constraints_node = constraints_login_node if submit_type == login_signup.LOGIN else constraints_signup_node
	
	ResourceLoader.load_threaded_request(MENU_SCENE_PATH)
	
	check_constraints()
	
	form.values().map(func(line_edit):
		line_edit.text_changed.connect(func(text): 
			check_constraints()
		)
	)
	
	var buttons_login_signup = login_signup_choice.get_children()
	buttons_login_signup.map(func(button: Button): 
		button.pressed.connect(func():
			submit_type = login_signup[login_signup.keys().filter(func(s): return button.name.to_upper() == s)[0]]
			constraints_node = constraints_login_node if submit_type == login_signup.LOGIN else constraints_signup_node
			check_constraints()
			
			$HBoxContainer/MarginContainer/Main/PasswordConfirm.modulate.a = 0 if submit_type == login_signup.LOGIN else 1
			$HBoxContainer/MarginContainer/Main/Constraints_Login.visible = submit_type == login_signup.LOGIN
			$HBoxContainer/MarginContainer/Main/Constraints_Signup.visible = submit_type == login_signup.SIGNUP
			
			buttons_login_signup.map(func(button2):
				var color = Color(0.6, 1, 0.7, 0.4) if button == button2 else Color(0, 0, 0, 0.5)
				button2.get_theme_stylebox("normal", "Button").bg_color = color
			)
		)
	)
	
func check_constraints():
	var constraints = constraints_login if submit_type == login_signup.LOGIN else constraints_signup
	
	validate.disabled = !constraints.keys().map(func(c): 
		var valid = constraints[c].call(form)
		var color = Color(0, 0.7, 0, 1) if valid else Color(0.6, 0.6, 0.6, 1)
		constraints_node.get_node(c).add_theme_color_override('font_color', color)
		
		return valid
	).all(func(c): return c)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func length_gt_7(form):
	return form['password'].text.length() > 7
	
func contains_special_char(form):
	var regex = RegEx.new()
	regex.compile("[^A-Za-z0-9]")
	
	return regex.search(form['password'].text) != null
	
func contains_number(form):
	var regex = RegEx.new()
	regex.compile("[0-9]")
	return regex.search(form['password'].text) != null
	
func contains_lower_upper(form):
	var regex_lower = RegEx.new()
	regex_lower.compile("[a-z]")
	
	var regex_upper = RegEx.new()
	regex_upper.compile("[A-Z]")
	
	return ![regex_lower.search(form['password'].text), regex_upper.search(form['password'].text)].any(func(r): return r == null)
	
func fields_required(form):
	return ![form['username'].text, form['password'].text].any(func(text: String): return text.is_empty())
	
func passwords_similar(form):
	return !form['password'].text.is_empty() && form['password'].text == form['password_confirm'].text

func _on_validate_pressed():
	if submit_type == login_signup.LOGIN:
		var can_login = await player_controller.login(form['username'].text, form['password'].text)
		
		if can_login is int: ##!!
			if can_login == PlayerException.LoginException.USERNAME_INCORRECT:
				ServiceScenes.announcer_ui.announce(
					"Username is incorrect : it doesn't exist", AnnounceUI.AnnounceKind.ERROR
				)
			elif can_login == PlayerException.LoginException.PASSWORD_INCORRECT:
				ServiceScenes.announcer_ui.announce("Password is incorrect", AnnounceUI.AnnounceKind.ERROR)
		else:
			load_menu_scene()
		
	else:
		var can_signup = await player_controller.signup(form['username'].text, form['password'].text)
		if can_signup is int && can_signup == PlayerException.SignupException.USERNAME_ALREADY_EXISTS:
			ServiceScenes.announcer_ui.announce("Username is already taken", AnnounceUI.AnnounceKind.ERROR)
			
		ServiceScenes.announcer_ui.announce("Account created succesfully", AnnounceUI.AnnounceKind.SUCCESS)
		_on_validate_pressed()

func load_menu_scene():
	var menu_scene = ResourceLoader.load_threaded_get(MENU_SCENE_PATH).instantiate()
	ServiceScenes.root_scene.add_child(menu_scene)
	self.queue_free()
