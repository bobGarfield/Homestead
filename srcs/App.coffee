class @App

	constructor : ->

	init : (opts) ->
		{paper, storage, canvas, interface} = opts
		{textures} = opts.resources

		player   = new Player.Hero

		@manager = new Manager
			'interface' : interface
			'textures'  : textures
			'storage'   : storage
			'canvas'    : canvas
			'player'    : player
			'paper'     : paper

	start : ->
		do @manager.start