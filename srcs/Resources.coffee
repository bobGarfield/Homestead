namespace "Resource", ->

	class @Storage
		constructor : (opts) ->
			@textures = []

			for name of (list = opts.textures) then do =>
				image     = new Image
				image.src = list[name]
				
				@textures[name] = image
