class @App

	constructor : ->
		ui = new Interface
			sections :
				menu    : '#menu'
				loader  : '#loader'
				options : '#options'
				game    : '#game'
				journal : '#journal'
				ingame  : '#ingame'

			buttons :
				launchGame : '.launchGame'
				stopGame   : '.stopGame'
				saveGame   : '.saveGame'

				switchJournal : '.switchJournal'
				switchGame    : '.switchGame'
				switchIngame  : '.switchIngame'
				switchLoader  : '.switchLoader'
				switchOptions : '.switchOptions'
				switchMenu    : '.switchMenu'

			lists :
				blockList : '#blockList'
				itemList  : '#itemList'
				saveList  : '#saveList'

		storage = new Storage
			texturesPath : 'ress/textures/'
			meshesPath   : 'ress/meshes/'
			audiosPath   : 'ress/audios/'

		canvas = $('canvas').first

		storage.loadMeshes   meshRegistrator.pack
		storage.loadTextures textureRegistrator.pack

		ui.init @

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
		return @controller.saveManager.saves