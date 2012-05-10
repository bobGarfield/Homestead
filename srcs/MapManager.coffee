# Import
{Map} = @

# Singleton
class @MapManager

	## Public
	constructor : ->
		@maps = []

	init : (storage) ->
		@load storage.meshes

		@current = @maps.first

	load : (meshes) ->
		{maps} = @

		index  = 0

		for mesh of meshes then do ->
			maps[index] = new Map meshes[mesh], index

			index++

	buildMap : (shapeManager) ->
		map = @current

		{width, height} = map

		height.times (y) ->
			width.times (x) ->
				relative = [x, y].point()
				point    = map.absoluteFrom relative

				if id = map.blockAt point
					shape = shapeManager.makeBlock id

					map.spawnBlock point, shape

	destroyMap : ->
		do @current.destroy

	rebuildMap : (shapeManager, side = 0) ->
		@updateMap side if side

		@buildMap shapeManager

	updateMap : (side) ->
		{index} = @current

		@select index+side

	select : (index) ->
		do @destroyMap

		@current = @maps[index]

	checkCurrent : (place) ->
		return @current isnt @maps[place]

	extract : ->
		return @maps.map (map) -> return map.matrix

	involve : (matrices) ->
		@maps.each (map, index) -> map.matrix = matrices[index]