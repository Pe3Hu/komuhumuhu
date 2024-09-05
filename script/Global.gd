extends Node


var rng = RandomNumberGenerator.new()
var arr = {}
var num = {}
var vec = {}
var color = {}
var dict = {}
var flag = {}
var node = {}
var scene = {}


func _ready() -> void:
	init_arr()
	init_num()
	init_vec()
	init_color()
	init_dict()
	
func init_arr() -> void:
	arr.kingdom = ["eagle", "horse", "lion", "elephant", "bear"]
	arr.building = ["road", "farm", "fort", "town"]
	
func init_num() -> void:
	num.index = {}
	
func init_dict() -> void:
	init_direction()
	init_corner()
	
	init_kingdom()
	init_dukedom()
	
func init_direction() -> void:
	dict.direction = {}
	dict.direction.linear3 = [
		Vector3( 0, 0, -1),
		Vector3( 1, 0,  0),
		Vector3( 0, 0,  1),
		Vector3(-1, 0,  0)
	]
	dict.direction.linear2 = [
		Vector2i( 0,-1),
		Vector2i( 1, 0),
		Vector2i( 0, 1),
		Vector2i(-1, 0)
	]
	dict.direction.diagonal = [
		Vector2i( 1,-1),
		Vector2i( 1, 1),
		Vector2i(-1, 1),
		Vector2i(-1,-1)
	]
	dict.direction.zero = [
		Vector2i( 0, 0),
		Vector2i( 1, 0),
		Vector2i( 1, 1),
		Vector2i( 0, 1)
	]
	dict.direction.hex = [
		[
			Vector2i( 1,-1), 
			Vector2i( 1, 0), 
			Vector2i( 0, 1), 
			Vector2i(-1, 0), 
			Vector2i(-1,-1),
			Vector2i( 0,-1)
		],
		[
			Vector2i( 1, 0),
			Vector2i( 1, 1),
			Vector2i( 0, 1),
			Vector2i(-1, 1),
			Vector2i(-1, 0),
			Vector2i( 0,-1)
		]
	]
	
	dict.direction.hybrid = []
	
	for _i in dict.direction.linear2.size():
		var direction = dict.direction.linear2[_i]
		dict.direction.hybrid.append(direction)
		direction = dict.direction.diagonal[_i]
		dict.direction.hybrid.append(direction)
	
	dict.reflect = {}
	var n = dict.direction.hybrid.size()
	
	for _i in n:
		var _j = (_i + n / 2) % n
		var origin_direction = dict.direction.hybrid[_i]
		var reflected_direction = dict.direction.hybrid[_j]
		dict.reflect[origin_direction] = reflected_direction
	
func init_corner() -> void:
	dict.order = {}
	dict.order.pair = {}
	dict.order.pair["even"] = "odd"
	dict.order.pair["odd"] = "even"
	var corners = [4]
	dict.corner = {}
	dict.corner.vector = {}
	
	for corners_ in corners:
		dict.corner.vector[corners_] = {}
		dict.corner.vector[corners_].even = {}
		
		for order_ in dict.order.pair.keys():
			dict.corner.vector[corners_][order_] = {}
		
			for _i in corners_:
				var angle = 2*PI*_i/corners_-PI/2
				
				if order_ == "odd":
					angle += PI/corners_
				
				var vertex = Vector2(1,0).rotated(angle)
				dict.corner.vector[corners_][order_][_i] = vertex
	
func init_kingdom() -> void:
	dict.kingdom = {}
	dict.kingdom.title = {}
	
	var path = "res://entities/kingdom/kingdom.json"
	var array = load_data(path)
	
	for kingdom in array:
		kingdom.dukedom = int(kingdom.dukedom)
		kingdom.earldom = int(kingdom.earldom)
		
		if !dict.kingdom.title.has(kingdom.title):
			dict.kingdom.title[kingdom.title] = {}
		
		if !dict.kingdom.title[kingdom.title].has(kingdom.dukedom):
			dict.kingdom.title[kingdom.title][kingdom.dukedom] = []
		
		dict.kingdom.title[kingdom.title][kingdom.dukedom].append(kingdom.earldom)
	
func init_dukedom() -> void:
	dict.dukedom = {}
	dict.dukedom.index = {}
	
	var path = "res://entities/dukedom/dukedom.json"
	var array = load_data(path)
	var exceptions = ["index"]
	
	for dukedom in array:
		dukedom.index = int(dukedom.index)
		if dukedom.has("garrison"):
			dukedom.garrison = int(dukedom.garrison)
		
		dict.dukedom.index[dukedom.index] = {}
		dict.dukedom.index[dukedom.index].garrison = int(0)
		
		for key in dukedom:
			if !exceptions.has(key):
				if key == "buildings":
					dict.dukedom.index[dukedom.index].buildings = dukedom[key].split(",")
				else:
					dict.dukedom.index[dukedom.index][key] = dukedom[key]
	
func init_vec():
	vec.size = {}
	vec.size.sixteen = Vector2(16, 16)
	
	init_window_size()
	
func init_window_size():
	vec.size.window = {}
	vec.size.window.width = ProjectSettings.get_setting("display/window/size/viewport_width")
	vec.size.window.height = ProjectSettings.get_setting("display/window/size/viewport_height")
	vec.size.window.center = Vector2(vec.size.window.width/2, vec.size.window.height/2)
	
func init_color():
	#var h = 360.0
	pass
	
func save(path_: String, data_: String):
	var path = path_ + ".json"
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(data_)
	
func load_data(path_: String):
	var file = FileAccess.open(path_, FileAccess.READ)
	var text = file.get_as_text()
	var json_object = JSON.new()
	var _parse_err = json_object.parse(text)
	return json_object.get_data()
	
func get_random_key(dict_: Dictionary):
	if dict_.keys().size() == 0:
		print("!bug! empty array in get_random_key func")
		return null
	
	var total = 0
	
	for key in dict_.keys():
		total += dict_[key]
	
	rng.randomize()
	var index_r = rng.randf_range(0, 1)
	var index = 0
	
	for key in dict_.keys():
		var weight = float(dict_[key])
		index += weight/total
		
		if index > index_r:
			return key
	
	print("!bug! index_r error in get_random_key func")
	return null
