class_name KingdomResource extends Resource


var planet: PlanetResource:
	set = set_planet
var type: String:
	set = set_type
var dukedoms: Array[DukedomResource]


func set_type(type_: String) -> KingdomResource:
	type = type_
	return self
	
func set_planet(planet_: PlanetResource) -> KingdomResource:
	planet = planet_
	planet.kingdoms.append(self)
	init_dukedoms()
	return self
	
func init_dukedoms() -> void:
	for index in Global.dict.kingdom.title[type]:
		var dukedom = DukedomResource.new()
		dukedom.set_index(index).set_kingdom(self)
