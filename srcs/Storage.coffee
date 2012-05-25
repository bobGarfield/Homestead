# File types
png = '.png'

# Import
{Mesh} = @

# Singleton
class @Storage

	## Private
	texturesPath = null
	audiosPath   = null
	meshesPath   = null

	## Public
	constructor : (paths) ->
		{texturesPath, audiosPath, mapsPath} = paths

		@textures = {}
		@audios   = {}
		@meshes   = {}
		@objects  = {}

	loadTextures : (pack) ->
		{textures} = @

		pack.each (alias) ->
			src = "#{texturesPath+alias+png}"
			
			textures[alias] = new Image
			textures[alias].src = src

	loadAudios : (pack) ->
		# TODO

	loadMeshes : (pack) ->
		{meshes} = @

		pack.each (matrix, index) ->
			mesh = new Mesh matrix

			mesh.index = index
		
			meshes[index] = mesh

	loadObjects : (pack) ->
		{objects} = @

		pack.each (data) ->
			objects[data.id] = data

	consecutiveTextures : (id) ->
		{textures} = @

		result = []

		pattern = ///#{id}\d///

		for alias of textures
			result.push textures[alias] if pattern.test alias

		return result