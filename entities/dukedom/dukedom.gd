class_name Dukedom extends Line2D


@export var area: Area2D
@export var collision: CollisionPolygon2D
@export var building: Building

var planet: Planet:
	set = set_planet
var resource: DukedomResource:
	set = set_resource


func set_planet(planet_: Planet) -> Dukedom:
	planet = planet_
	planet.dukedoms.add_child(self)
	
	init_vertexs()
	set_garrison(resource.garrison)
	building.frame = resource.sprite_frame
	return self
	
func set_resource(resource_: DukedomResource) -> Dukedom:
	resource = resource_
	return self
	
func init_vertexs() -> void:
	width = resource.planet.dukedom_width
	var w = 0#width / 2
	var a = Vector2(resource.left_top) * resource.planet.earldom_size
	var b = Vector2(resource.right_bottom + Vector2i.ONE) * resource.planet.earldom_size
	building.position = (a + b) / 2
	var vertexs = [
		Vector2(a.x + w, a.y + w),
		Vector2(b.x - w, a.y + w),
		Vector2(b.x - w, b.y - w),
		Vector2(a.x + w, b.y - w),
		Vector2(a.x + w, a.y - width / 2)
	]
	
	collision.set_polygon(vertexs)
	
	for vertex in vertexs:
		add_point(vertex)
	
func set_garrison(garrison_: int) -> void:
	resource.garrison = garrison_
	building.garrison.visible = resource.garrison > 0
	
	if resource.garrison > 0:
		building.garrison.text = str(resource.garrison)
	
func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				print(["origin", resource.kingdom.type, resource.index])
				
				for neighbor in resource.neighbors:
					print(["neighbor", neighbor.kingdom.type, neighbor.index])
