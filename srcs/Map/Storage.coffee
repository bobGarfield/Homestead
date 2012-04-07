## Constants
space = /\s/

interpret = (string) ->
	arr = string.split space
	arr.each (row, index) ->
		arr[index] = row.split ''

	return arr

namespace "Map", ->

	## Import
	{Location} = @

	class @Storage
		constructor : ->
			@maps = []

		follow : (side) ->
			{maps, current } = @
			{index         } = current

			maps[index] = current

			if (map = maps[index+side])
				@current = map
				return true

		load : (maps) ->
			maps.each (mesh, index) ->
				matrix = interpret mesh
				map    = new Location(matrix, index)

				maps[index] = map
			
			@maps    = maps
			@current = maps.first