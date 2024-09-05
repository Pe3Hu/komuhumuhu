class_name DukedomResource extends Resource


var planet: PlanetResource
var kingdom: KingdomResource:
	set = set_kingdom
var index: int:
	set = set_index
var earldoms: Array[EarldomResource]
var neighbors: Array[DukedomResource]
var left_top: Vector2i
var right_bottom: Vector2i
var garrison: int
var buildings: Array
var sprite_frame: int


func set_index(index_: int) -> DukedomResource:
	index = index_
	var description = Global.dict.dukedom.index[index]
	buildings.append_array(description.buildings)
	garrison = description.garrison
	sprite_frame = Global.arr.building.find(buildings[0])
	
	if buildings.size() > 1:
		var value = int(0)
		
		for building in buildings:
			var degree = Global.arr.building.find(building)
			value += int(pow(2, degree))
		
		match value:
			6:
				sprite_frame = 4
			10:
				sprite_frame = 5
			12:
				sprite_frame = 6
	
	return self
	
func set_kingdom(kingdom_: KingdomResource) -> DukedomResource:
	kingdom = kingdom_
	planet = kingdom_.planet
	kingdom.dukedoms.append(self)
	planet.dukedoms.append(self)
	init_earldoms()
	return self
	
func init_earldoms() -> void:
	for earldom_index in Global.dict.kingdom.title[kingdom.type][index]:
		var earldom = EarldomResource.new()
		earldom.set_index(earldom_index).set_dukedom(self)
	
	left_top = Vector2i(earldoms[0].grid)
	right_bottom = Vector2i(earldoms[0].grid)
	
	for earldom in earldoms:
		if earldom.grid.x >= right_bottom.x and earldom.grid.y >= right_bottom.y:
			right_bottom = earldom.grid
		if earldom.grid.x <= left_top.x and earldom.grid.y <= left_top.y:
			left_top = earldom.grid
