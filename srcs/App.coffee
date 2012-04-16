class @App

	constructor : ->

	init : (opts) ->
		{paper, storage, canvas, interface} = opts
		{textures} = opts.resources

		player = new Player.Hero

		@controller = new Control.Controller
			'interface' : interface
			'textures'  : textures
			'storage'   : storage
			'canvas'    : canvas
			'player'    : player
			'paper'     : paper

		do localStorage.clear

	start : ->
		do @controller.start

	loadState : (key) ->
		data = JSON.parse localStorage.getItem(key)

		@controller.import data

	saveGame : ->
		state = @controller.export().stringify()
		key   = state.time

		localStorage.setItem(key, state.data)

	getSaves : ->
		states = {}

		for time, data of localStorage
			states[time] = JSON.parse data

		return states