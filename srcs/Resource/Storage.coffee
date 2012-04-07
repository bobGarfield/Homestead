namespace "Resource", ->

	class @Storage
		constructor : ->

		load : (opts) ->
			textures = {}

			for name of (list = opts.textures)
				image     = new Image
				image.src = list[name]
				
				textures[name] = image

			@textures = textures
