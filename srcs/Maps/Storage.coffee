## Constants
space = /\s/

translate = (string) ->
	arr = string.split space
	arr.each (row, index) =>
		arr[index] = row.split ''

	return arr

interpret = (map) ->
	arr = map.matrix

	arr.each (row, index) =>
		arr[index] = row.join ''

	arr.join space


namespace "Maps", ->

	## Import
	{Location} = @

	class @Storage
		constructor : ->
			@maps = []

		follow : (side) ->
			{maps, current } = @
			{index         } = current

			do @save

			if (map = maps[index+side])
				@current = map
				return true

		loadMeshes : (maps) ->
			maps.each (mesh, index) ->
				matrix = translate mesh
				map    = new Location(matrix, index)

				maps[index] = map
			
			@maps    = maps
			@current = maps.first

		save : ->
			{current} = @
			{index  } = current

			@maps[index] = current


		change : (index) ->
			{maps, current} = @

			@current = maps[index] || current