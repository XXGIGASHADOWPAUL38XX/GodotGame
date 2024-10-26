class_name Gdict

func serialize_to_dict(value):
	if typeof(value) == TYPE_ARRAY:
		var serialized_array = []
		for item in value:
			serialized_array.append(serialize_to_dict(item))
		return serialized_array
	elif typeof(value) == TYPE_OBJECT:
		var serialized_dict = {}
		return inst_to_dict(value)
	else:
		return value
		
func deserialize_from_dict(value):
	if typeof(value) == TYPE_ARRAY:
		var deserialized_array = []
		for item in value:
			deserialized_array.append(deserialize_from_dict(item))
		return deserialized_array
	elif typeof(value) == TYPE_DICTIONARY:
		var deserialized_object = dict_to_inst(value)
		if deserialized_object != null:
			return deserialized_object
		else:
			return value
	else:
		return value
