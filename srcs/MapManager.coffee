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

		for key of meshes then do ->
			maps.push new Map meshes[key]

	decomposeMap : ->
		do @current.decompose

	composeMap : (objectManager) ->
		@current.compose objectManager

	recomposeMap : (objectManager, side = 0) ->
		do @decomposeMap

		@updateCurrent side if side

		@composeMap objectManager

	updateCurrent : (side) ->
		{index} = @current

		@select index+side

	select : (index) ->
		@current = @maps[index]

	checkCurrent : (place) ->
		return @current isnt @maps[place]

	extract : ->
		return @maps.map (map) ->
			return map.matrix

	involve : (matrices) ->
		@maps.each (map, index) -> map.matrix = matrices[index]