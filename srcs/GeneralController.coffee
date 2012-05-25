{MapManager, SaveManager, EventManager, ShapeManager, AnimationManager} = @

## Vectors
left  =  [-5,   0].point()
right =  [ 5,   0].point()
up    =  [ 0, -50].point()
down  =  [ 0,   5].point()

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
		@objectManager    = new ObjectManager
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

		@objectManager .init @storage, @shapeManager, @animationManager
		@mapManager    .init @storage

		@ui.linkAggregates
			'inventory' : @player.inventory

		do @initPlayer
		do @initGameloop
		do @initAnimation
		do @initActions

		@mapManager.composeMap @objectManager

		@save('New Game') unless @load('New Game')

	stop : ->
		{camera} = paper.view

		do @mapManager.decomposeMap

		do camera.reset

		do paper.project.remove
		do paper.tool.remove

	initPlayer : ->
		{camera} = paper.view

		map   = @mapManager.current
		point = map.points.left

		shirt  = @objectManager.make 'equipment', 'shirt'
		helmet = @objectManager.make 'equipment', 'helmet'
		drill  = @objectManager.make 'weapon',    'drill'

		@player.init
			weapon    : drill
			equipment :
				head : helmet
				body : shirt
			point

	initGameloop : ->
		{mapManager, objectManager} = @

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
					mapManager.recomposeMap objectManager, 1

					player.spawn map.points.left

				camera.observe player.body

			if key.isDown(walkLeftKey) and map.checkX(player.head, player.body, -1)
				player.move left

				if map.checkBorder(player.body, 'left') and mapManager.checkCurrent('first')
					mapManager.recomposeMap objectManager, -1

					player.spawn map.points.right

				camera.observe player.body

			if map.checkY(player.body, 1)
				player.move down

				camera.observe player.body

				return

			if key.isDown(jumpKey) and map.checkY(player.head, -1)
				player.move up

				camera.observe player.body

	initAnimation : ->
		{animationManager, player} = @
		key = paper.Key

		@eventManager.setAnimationOnHandler (event) ->
			if key.isDown walkKey
				do player.straighten
				for object in player.inventory.objects
					animationManager.animate object if object.animatable

			else if key.isDown walkLeftKey
				do player.reverse
				for object in player.inventory.objects
					animationManager.animate object if object.animatable

		@eventManager.setAnimationOffHandler (event) ->
			if event.key is walkKey or event.key is walkLeftKey
				for object in player.inventory.objects
					animationManager.hold object if object.animatable

	initActions : ->
		{ui, mapManager, shapeManager, objectManager} = @

		{player} = @
		{camera} = paper.view

		{inventory} = player

		@eventManager.setAttackHandler (event) ->
			map = mapManager.current ; point = event.point.add camera.box

			shapeManager.drawRay 'white', player.hand, point

			point.x -= map.cellSize/4

			block = map.delete point

			player.pick block

		@eventManager.setAlternativeHandler (event) ->
			map = mapManager.current ; point = event.point.add camera.box

			point.x -= map.cellSize/4

			return if map.at point

			block = inventory.currentBlock

			return ui.showMessage('Ran out of blocks') unless block

			map.insert block, point

	save : (key) ->
		{player} = @

		map = @mapManager.current

		do @mapManager.decomposeMap

		pdata =
			'coordinate' : player.body
			'container'  : player.inventory.container

		mdata =
			'matrices' : @mapManager.extract()
			'index'    : map.index

		@mapManager.composeMap @objectManager

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

		do @mapManager.decomposeMap

		mapManager.involve mdata.matrices
		mapManager.select  mdata.index

		coordinate = new paper.Point pdata.coordinate

		player.spawn coordinate
		player.inventory.container.set pdata.container

		mapManager.composeMap @objectManager

		camera.observe player.body

		return true