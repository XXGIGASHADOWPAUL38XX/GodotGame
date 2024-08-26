extends Node

var recently_freed_nodepaths: Array:
	get:
		if recently_freed_nodepaths.size() > 5:
			recently_freed_nodepaths.remove_at(0)
		print(recently_freed_nodepaths)
		return recently_freed_nodepaths

func all_remotes(node, f, args:Array):
	args = convert_args_to_nodepaths(args)
	rpc('f_rpc', f, node.get_path(), args)
	
func remote_only(id, node, f, args:Array):
	args = convert_args_to_nodepaths(args)
	rpc_id(id, 'f_rpc', f, node.get_path(), args)
	
func any(node, f, args:Array):
	node.callv(f, args)
	all_remotes(node, f, args)

@rpc("any_peer")
func f_rpc(f, path, args, retry_instances=3, retry_interval=0.05):
	args = convert_args_to_nodes(args)
	
	var node = get_node(path as String)
	
	while node == null && retry_instances > 0:
		await get_tree().create_timer(retry_interval).timeout
		node = get_node(path as String)
		retry_instances -= 1
		
	# SI LE NODE A ETE SUPPRIME RECEMMENT POUR L'AUTORITHE A APPELLEE DEPUIS L'AUTHORITE B
	if retry_instances == 0 && recently_freed_nodepaths.any(func(rfn): return rfn == node):
		return
	
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
		
func send_to_ennemies(node, f, args):
	for ennemy in ServiceScenes.ennemiesNode:
		remote_only(ennemy.get_multiplayer_authority(), node, f, args)
	
func convert_args_to_nodepaths(args):
	for i in range(args.size()):
		if args[i] is Node2D:
			args[i] = args[i].get_path()
		elif args[i] is Array:
			args[i] = convert_args_to_nodepaths(args[i].duplicate())
	return args
	
func convert_args_to_nodes(args):
	for i in range(args.size()):
		if (args[i] is NodePath):
			args[i] = get_node(args[i] as String)
		elif args[i] is Array:
			args[i] = convert_args_to_nodes(args[i])
			
	return args

func set_any(node, atr_string, value):
	any(self, 'set_n', [node, atr_string, value])
	
func set_n(node, atr_string, value):
	node.set(atr_string, value)
