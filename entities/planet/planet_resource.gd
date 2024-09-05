class_name PlanetResource extends Resource


var kingdoms: Array[KingdomResource]
var dukedoms: Array[DukedomResource]
var earldoms: Array[EarldomResource]
var grids: Dictionary

const earldom_grid = Vector2i(19, 17)
const earldom_size = Vector2(32, 32)
const dukedom_width = 4


func _init() -> void:
	init_kingdoms()
	init_neighbors()
	
func init_kingdoms() -> void:
	for type in Global.dict.kingdom.title:
		var kingdom = KingdomResource.new()
		kingdom.set_type(type).set_planet(self)
	
func init_neighbors() -> void:
	for earldom in earldoms:
		for direction in Global.dict.direction.linear2:
			var neighbor_grid = earldom.grid + direction
			
			if grids.has(neighbor_grid):# and !earldom.neighbors.has(neighbor_grid)
				earldom.neighbors.append(grids[neighbor_grid])
	
	for dukedom in dukedoms:
		for earldom in dukedom.earldoms:
			for neighbor_earldom in earldom.neighbors:
				if neighbor_earldom.dukedom != dukedom and !dukedom.neighbors.has(neighbor_earldom.dukedom):
					dukedom.neighbors.append(neighbor_earldom.dukedom)
	
	pass
	
