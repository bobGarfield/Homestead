## Paths
texturesPath = 'ress/textures/'
audiosPath   = 'ress/audios/'
meshesPath   = 'ress/meshes/'

## File types
png = '.png'

## Regexp patterns
space = /\s/

## Auxiliary functions

# Translate mesh to matrix
translate = (mesh) ->
	matrix = mesh.split space
	matrix.each (row, index) =>
		matrix[index] = row.split ''

	return matrix

# Extract matrix and make mesh
interpret = (location) ->
	{matrix} = location
	copy     = matrix

	matrix.each (row, index) =>
		copy[index] = row.join ''

	mesh = copy.join space

	return mesh

## Import
Location = Maps.Location

namespace "Resources", ->

	# Singleton
	class @Storage
		constructor : ->
			@textures = {}
			@audios   = {}
			@maps     = []

			@currentLocation = null

		## Data

		# Load textures
		loadTextures : (pack) ->
			{textures} = @

			pack.each (alias) ->
				src = "#{texturesPath+alias+png}"
				
				textures[alias] = new Image
				textures[alias].src = src

		# Load audios
		loadAudios : (pack) ->
			#TODO

		## Locations
		
		# Load meshes
		meshesPack = null

		loadMeshes : (pack) ->
			{maps} = @

			meshesPack ?= pack

			pack.each (mesh, index) ->
				matrix = translate mesh

				map = new Location(matrix)
				map.index = index
			
				maps[index] = map

			@currentLocation = maps.first

		reloadMeshes : ->
			@loadMeshes meshesPack

		changeLocation : (index) ->
			@currentLocation = @maps[index]

		saveCurrentLocation : ->
			{index} = @currentLocation

			@maps[index] = @currentLocation

		applyNeighborFrom : (side) ->
			{index} = @currentLocation
			{maps } = @

			do @saveCurrentLocation

			if maps[index+side]
				@changeLocation(index+side)
				return true
			else
				return false