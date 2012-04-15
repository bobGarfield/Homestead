class @App

	constructor : ->

	init : (opts) ->
		{paper, storage, canvas, interface} = opts
		{textures} = opts.resources

		player   = new Player.Hero

		@manager = new Control.Manager
			'interface' : interface
			'textures'  : textures
			'storage'   : storage
			'canvas'    : canvas
			'player'    : player
			'paper'     : paper

		do localStorage.clear

	start : ->
		do @manager.start

	loadState : (key) ->
		data = JSON.parse localStorage.getItem(key)

		@manager.import data

	saveGame : ->
		state = @manager.export().stringify()
		key   = state.time

		localStorage.setItem(key, state.data)

	getSaves : ->
		states = {}

		for time, data of localStorage
			states[time] = JSON.parse data

		return states