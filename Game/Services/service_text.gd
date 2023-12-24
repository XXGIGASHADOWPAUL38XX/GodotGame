extends Node2D

func display_text(text, color, logo=null):
	display_text_rpc(ServiceScenes.championNode, text, color, logo)
	Servrpc.any(self, 'display_text_rpc', [ServiceScenes.championNode, text, color, logo])

func display_text_local(text, color, logo=null):
	display_text_rpc(ServiceScenes.championNode, text, color, logo)

func display_text_rpc(heros, text, color, logo=null):
	var node_text = HBoxContainer.new()
	
	if logo != null:
		var logo_texture = TextureRect.new()
		logo_texture.custom_minimum_size = Vector2(25, 25)
		logo_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		logo_texture.texture = logo
		node_text.add_child(logo_texture)
	
	var label = Label.new()
	label.text = text
	label.add_theme_color_override('font_color', color)
	node_text.add_child(label)

	node_text.position = ServiceSpell.set_random_pos(30)
	heros.add_child(node_text)
	
	for i in range(12):
		node_text.position.y -= 3
		node_text.modulate.a -= 0.05
		await node_text.get_tree().create_timer(0.03).timeout

	heros.remove_child(node_text)
