class @App

	constructor : ->

	init : (pack) ->
		{paper, storage, canvas, ui} = pack

		player = new Player.Hero

		@controller = new Control.Controller
			'storage' : storage
			'canvas'  : canvas
			'player'  : player
			'paper'   : paper
			'ui'      : ui

		do localStorage.clear

	start : ->
		do @controller.start

	loadGame : (key) ->
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