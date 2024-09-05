class_name EarldomResource extends Resource


var planet: PlanetResource
var dukedom: DukedomResource:
	set = set_dukedom
var index: int:
	set = set_index
var grid: Vector2i
var neighbors: Array[EarldomResource]


func set_index(index_: int) -> EarldomResource:
	index = index_
	return self
	
func set_dukedom(dukedom_: DukedomResource) -> EarldomResource:
	dukedom = dukedom_
	planet = dukedom.planet
	dukedom.earldoms.append(self)
	planet.earldoms.append(self)
	grid = Vector2i(index % planet.earldom_grid.x, index / planet.earldom_grid.x)
	planet.grids[grid] = self
	return self
