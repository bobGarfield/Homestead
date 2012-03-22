class @App

	constructor : ->

	init : (opts) ->
		{paper, matrix, canvas, resources, interface} = opts

		map    = new Map(matrix)
		player = new Player.Hero

		@manager = new Manager
			interface  : interface
			textures  : resources.textures
			canvas    : canvas
			player    : player
			paper     : paper
			map       : map

	start : ->
		do @manager.start