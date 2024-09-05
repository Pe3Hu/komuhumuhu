class_name Planet extends PanelContainer


@export var world: World
@export var fiefdoms: TileMapLayer
@export var dukedoms: Node2D

@onready var dukedom_scene = preload("res://entities/dukedom/dukedom.tscn")

var resource: PlanetResource


func _ready() -> void:
	resource = PlanetResource.new()
	
	init_fiefdoms()
	init_dukedoms()
	
func init_fiefdoms() -> void:
	custom_minimum_size = resource.earldom_size * Vector2(resource.earldom_grid)
	var source_id = 0
	
	for kingdom_resource in resource.kingdoms:
		var atlas_coords = Vector2i(Global.arr.kingdom.find(kingdom_resource.type), 0)
		
		for dukedom_resource in kingdom_resource.dukedoms:
			for earldom_resource in dukedom_resource.earldoms:
				fiefdoms.set_cell(earldom_resource.grid, source_id, atlas_coords)
	
	var style = get("theme_override_styles/panel")
	style.set("expand_margin_left", resource.dukedom_width / 2)
	style.set("expand_margin_top", resource.dukedom_width / 2)
	style.set("expand_margin_right", resource.dukedom_width / 2)
	style.set("expand_margin_bottom", resource.dukedom_width / 2)
	
	
func init_dukedoms() -> void:
	for kingdom_resource in resource.kingdoms:
		for dukedom_resource in kingdom_resource.dukedoms:
			var dukedom = dukedom_scene.instantiate()
			dukedom.set_resource(dukedom_resource).set_planet(self)
