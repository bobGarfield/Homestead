class @Resources
	constructor : (opts) ->
		@textures = []

		for name of (list = opts.textures) then do =>
			image     = new Image
			image.src = list[name]
			
			@textures[name] = image
