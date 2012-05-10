{MapManager, SaveManager, EventManager, ShapeManager, AnimationManager} = @

## Directions
left  =  -5 #[px]
right =   5 #[px]
up    = -50 #[px]
down  =   5 #[px]

## Keyboard keys
walkLeftKey    = 'a'
walkKey        = 'd'
jumpKey        = 'space'
openJournalKey = 'j'

## Mouse buttons
leftButton  = 0
rightButton = 2

## Sides
leftSide  = -1
rightSide =  1

# Singleton
class @GeneralController

	## Private
	paper = null

	## Public
	constructor : (parts) ->
		{@storage, @ui, @canvas, paper} = parts

		@player = new Player

		@animationManager = new AnimationManager
		@shapeManager     = new ShapeManager
		@eventManager     = new EventManager
		@saveManager      = new SaveManager
		@mapManager       = new MapManager

	init : ->
		paper.setup @canvas

		do paper.initCamera

		@animationManager.init paper
		@eventManager    .init paper
		@shapeManager    .init paper, @storage

		@mapManager .init @storage

		@ui.linkAggregates
			'inventory' : @player.inventory

		@mapManager.buildMap @shapeManager

		do @initPlayer
		do @initGameloop
		do @initAnimation
		do @initActions

		@save('New Game') unless @load('New Game')

	stop : ->
		{camera} = paper.view

		do @mapManager.destroyMap
		do @player.reset

		do camera.reset

		do paper.project.remove
		do paper.tool.remove

	initPlayer : ->
		{camera} = paper.view

		map   = @mapManager.current
		point = map.points.left
		shape = @shapeManager.makeCreature 'player'

		@player.shape = shape

		@player.spawn point

		camera.observe @player.body

	initGameloop : ->
		{mapManager, shapeManager} = @

		{player       } = @
		{camera       } = paper.view
		{width, height} = camera

		key = paper.Key

		@eventManager.setGameloopHandler ->
			map = mapManager.current

			cx = camera.point.x ; cy = camera.point.y

			if key.isDown(walkKey) and map.checkX(player.head, player.body, 0)
				player.move right

				if map.checkBorder(player.body, 'right') and mapManager.checkCurrent('last')
					mapManager.rebuildMap shapeManager, 1

					player.spawn map.points.left

				camera.observe player.body

			if key.isDown(walkLeftKey) and map.checkX(player.head, player.body, -1)
				player.move left

				if map.checkBorder(player.body, 'left') and mapManager.checkCurrent('first')
					mapManager.rebuildMap shapeManager, -1

					player.spawn map.points.right

				camera.observe player.body

			if map.checkY(player.body, 1)
				player.fall down

				camera.observe player.body

				return

			if key.isDown(jumpKey) and map.checkY(player.head, -1)
				player.jump up

				camera.observe player.body

	initAnimation : ->
		{animationManager, storage} = @
		{shape   } = @player
		{textures} = storage

		key = paper.Key

		runSprites     = storage.consecutiveTextures 'playerRun'
		runLeftSprites = storage.consecutiveTextures 'playerRunLeft'
		
		animationManager.makeAnimation shape, 'run',     runSprites
		animationManager.makeAnimation shape, 'runLeft', runLeftSprites

		@eventManager.setAnimationOnHandler (event) ->
			if key.isDown walkKey
				animationManager.request 'run'

			else if key.isDown walkLeftKey
				animationManager.request 'runLeft'

		@eventManager.setAnimationOffHandler (event) ->
			if event.key is walkKey
				animationManager.cancel 'run'

				shape.image = textures.player

			else if event.key is walkLeftKey
				animationManager.cancel 'runLeft'

				shape.image = textures.playerLeft

	initActions : ->
		{ui, mapManager, shapeManager} = @

		{inventory} = @player
		{camera   } = paper.view

		@eventManager.setAttackHandler (event) ->
			map = mapManager.current ; point = event.point.add camera.box

			point.x -= map.cellSize/4

			id = map.blockAt point

			inventory.put id

			map.destroyBlockAt point

		@eventManager.setAlternativeHandler (event) ->
			map = mapManager.current ; point = event.point.add camera.box

			point.x -= map.cellSize/4

			return if map.blockAt point

			id = inventory.takeBlock()

			return ui.showMessage('Ran out of blocks') unless id

			shape = shapeManager.makeBlock id

			map.putBlock point, id, shape

	save : (key) ->
		{player} = @

		map = @mapManager.current

		pdata =
			'coordinate' : player.coordinate
			'container'  : player.inventory.container

		mdata =
			'matrices' : @mapManager.extract()
			'index'    : map.index

		@saveManager.save new State
			'player'     : pdata
			'mapManager' : mdata,
			key or null

	load : (key) ->
		{player, mapManager} = @
		{camera} = paper.view

		state = @saveManager.load(key)

		return false unless state

		do state.parse

		pdata = state.data.player
		mdata = state.data.mapManager

		mapManager.involve mdata.matrices
		mapManager.select  mdata.index

		coordinate = new paper.Point pdata.coordinate

		player.spawn coordinate
		player.inventory.container.set pdata.container

		mapManager.buildMap @shapeManager

		camera.observe player.body

		return true