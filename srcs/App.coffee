class @App

	constructor : ->

	init : (pack) ->
		{paper, storage, canvas, ui} = pack

		@controller = new GeneralController
			'storage' : storage
			'canvas'  : canvas
			'paper'   : paper
			'ui'      : ui

	launchGame : ->
		do @controller.init

	stopGame : ->
		do @controller.stop

	loadGame : (key) ->
		@controller.load key

	saveGame : ->
		do @controller.save

	getSaves : ->
		states = {}

		for time, data of localStorage
			states[time] = JSON.parse data

		return states