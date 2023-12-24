extends Node

func all_remotes(node, f, args:Array):
	for i in range(args.size()):
		if args[i] is Node2D:
			args[i] = args[i].get_path()

	rpc('f_rpc', f, node.get_path(), args)
	
func remote_only(id, node, f, args:Array):
	for i in range(args.size()):
		if args[i] is Node2D:
			args[i] = args[i].get_path()

	rpc_id(id, 'f_rpc', f, node.get_path(), args)
	
func any(node, f, args:Array):
	node.callv(f, args)
	all_remotes(node, f, args)

@rpc("any_peer")
func f_rpc(f, path, args):
	for i in range(args.size()):
		if (args[i] is NodePath):
			args[i] = get_node(args[i] as String)
	
	var node = get_node(path as String)
	
	node.callv(f, args)

func send_to_multi_auth(node, f, args:Array):
	if node.is_multiplayer_authority(): 
		node.callv(f, args)
	else: 
		remote_only(node.get_multiplayer_authority(), node, f, args)

func send_to_id(id, node, f, args):
	if id == ServiceScenes.champion.id:
		node.callv(f, args)
	else:
		remote_only(id, node, f, args)

func send_to_ally(node, f, args):
	remote_only(ServiceScenes.ally.id, node, f, args)
		
func send_to_ennemies(id, node, f, args):
	remote_only(ServiceScenes.ennemy1.id, node, f, args)
	remote_only(ServiceScenes.ennemy2.id, node, f, args)
	
