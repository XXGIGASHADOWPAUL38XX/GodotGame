extends Node

func is_dp_base_node(node):
	return node.get_parent() is IDuplication && !node.has_meta("dp_id")
