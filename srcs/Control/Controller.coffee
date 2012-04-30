## Constants
all   =  4

## Directions
left  =  -5 #[px]
right =   5 #[px]
up    = -50 #[px]
down  =   5 #[px]

## Vectors
toLeft  = [left,  0].point()
toRight = [right, 0].point()
toUp    = [0,    up].point()
toDown  = [0,  down].point()

## Keyboard keys
walkLeftKey    = 'a'
walkKey        = 'd'
openJournalKey = 'j'
makeJumpKey    = 'space'

## Mouse buttons
leftButton  = 0
rightButton = 2

## Sides
leftSide  = -1
rightSide =  1

namespace "Control", ->
	
	## Import
	{State} = @
	{Hero } = Player
	
	class @Controller

		constructor : (pack) ->
			{@storage, @ui, @canvas, @paper} = pack

		## Process control

		start : ->
			{ui, player, storage, paper, canvas} = @

			paper.setup canvas

			@player   = new Hero
			@location = storage.currentLocation

			# Contact with ui
			@ui.linkAggregates
				'inventory' : @player.inventory

			do @buildLocation
			do @spawnPlayer
			do @initCamera
			do @defineHandlers

		stop : ->
			do @deleteLocation
			do @deleteCamera
			do @deletePlayer
			do @revertStorage

			do @paper.project.remove

		## Camera
		
		# Init Camera
		initCamera : ->
			do @paper.initCamera

		# Delete Camera
		deleteCamera : ->
			do @paper.resetCamera

		## Handlers

		defineHandlers : ->
			do @defineLoopHandler
			do @defineAnimationHandler
			do @defineMouseHandler

		# Define keyboard handlers
		defineAnimationHandler : ->
			{textures     } = @storage
			{paper, player} = @

			key = @paper.Key

			runSprites = [
				textures.playerRun0,
				textures.playerRun1,
				textures.playerRun2,
				textures.playerRun3,
				textures.playerRun4,
				textures.playerRun5
			]

			runLeftSprites = [
				textures.playerRunLeft0,
				textures.playerRunLeft1,
				textures.playerRunLeft2,
				textures.playerRunLeft3,
				textures.playerRunLeft4,
				textures.playerRunLeft5
			]

			run     = new @paper.SpriteAnimation player.shape, runSprites
			runLeft = new @paper.SpriteAnimation player.shape, runLeftSprites

			paper.view.onFrame = ->
				if key.isDown walkKey
					do run.request
				
				else if key.isDown walkLeftKey
					do runLeft.request

			paper.tool.onKeyUp = (event) ->
				if event.key is walkKey
					do run.cancel

					player.shape.image = textures.player

				if event.key is walkLeftKey
					do runLeft.cancel

					player.shape.image = textures.playerLeft

		# Define mouse handlers
		defineMouseHandler : ->
			{paper} = @
			
			# Defining onMouseDown handler
			@paper.tool.onMouseDown = (event) =>
				{location } = @
				{inventory} = @player
				{camera   } = paper.view

				point = event.point.add camera.point
				
				# Adjusting for camera and whole cell
				point.x -= Maps.qcellSize

				# Thanks to motherfucking paper.js for this
				{button} = event.event

				switch button
					# Harm block (by left mouse button)
					when leftButton
						id = location.blockAt point

						inventory.put id

						location.destroyBlockAt point
					
					# Put block (by right mouse button)
					when rightButton
						id    = inventory.takeBlock()
						
						shape = @makeBlock id
						
						location.putBlock point, id, shape

		# Define gameloop
		defineLoopHandler : ->
			{storage, paper, player} = @
			{camera                } = paper.view
			{width, height         } = camera

			key = @paper.Key

			# Defining onFrame handler
			paper.view.onFrame = =>
				{location} = @

				cx = camera.point.x
				cy = camera.point.y
				
				# Checking right side
				if key.isDown walkKey

					# Checking location
					if location.checkX player.head, player.body, 0
						player.move right

						# Checking location change
						if location.checkBorder player.body, 'right'
							if storage.applyNeighborFrom rightSide
								do @rebuildLocation

								@respawnPlayerFrom 'left'

								toTarget = location.points.end.negate()

								camera.translate toTarget

						# Checking camera
						if player.body.x > width/2 and location.checkWidth cx+width
							camera.translate toRight

				# Checking left
				if key.isDown walkLeftKey
					
					# Checking location
					if location.checkX player.head, player.body, -1
						player.move left

						# Checking location change
						if location.checkBorder player.body, 'left'
							if storage.applyNeighborFrom leftSide
								do @rebuildLocation

								@respawnPlayerFrom 'right'

								toTarget = location.points.end

								camera.translate toTarget

						# Checking camera
						if cx > 0 and location.checkWidth player.body.x+width/2
							camera.translate toLeft

				# Checking gravity
				if location.checkY player.body, 1
					player.fall down

					# Checking camera
					if location.checkHeight(cy+height) and player.body.y > height/2
						camera.translate toDown

					return

				# Checking jump
				if key.isDown makeJumpKey

					# Checking location
					if location.checkY player.head, -1
						player.jump up

						# Checking camera
						if cy > 0 and location.checkHeight player.body.y+height/2
							camera.translate toUp

		## Player

		# Spawn player by default
		spawnPlayer : ->
			{player  } = @
			{points  } = @location
			{textures} = @storage
			
			texture = textures.player
			point   = points.left.clone()
			
			player.shape = new @paper.Raster texture
			
			player.spawn point

		deletePlayer : ->
			@player = null

		# Respawn player from side
		respawnPlayerFrom: (side) ->
			{player} = @
			{points} = @location

			point   = points[side].clone()
			point.y = player.body.y

			player.spawn point

		## Location

		# Build location
		buildLocation : ->
			{location     } = @
			{width, height} = location

			height.times (y) =>
				width.times (x) =>
					relative = [x, y].point()
					point    = Maps.absoluteFrom relative
					
					# If there must be block
					if id = location.blockAt point
						shape = @makeBlock id

						location.spawnBlock point, shape

		# Update location
		updateLocation : ->
			@location = @storage.currentLocation

		# Destroy location
		destroyLocation : ->
			do @location?.destroy

		rebuildLocation : ->
			do @destroyLocation
			do @updateLocation
			do @buildLocation

		deleteLocation : ->
			@location = null

		makeBlock : (id) ->
			return null unless id

			{textures} = @storage
			
			texture = textures["#{id+all.rand()}"]

			return new @paper.Raster texture

		## State

		# Export state
		export : ->
			{location, player, storage} = @
			{camera                   } = @paper.view

			extracter = (location) ->
				return location.matrix

			do storage.saveCurrentLocation

			pdata =
				'coord'     : player.coord
				'container' : player.inventory.container

			vdata =
				'point'    : camera.point

			sdata =
				'maps'      : storage.maps.map extracter
				'index'     : location.index

			return new State
				'player'  : pdata
				'view'    : vdata
				'storage' : sdata

		# Import state
		import : (state) ->
			{paper} = @

			pdata = state.player
			vdata = state.view
			sdata = state.storage

			# Setting location state
			{storage    } = @
			{maps, index} = sdata

			storage.maps.each (location, index) ->
				location.matrix = maps[index]

			storage.changeLocation index

			do @rebuildLocation

			# Setting player state
			{player} = @
			{coord } = pdata

			point = new paper.Point coord
			player.spawn point

			# Setting inventory state
			{container} = pdata
			{inventory} = player

			inventory.container.set container

			# Setting camera
			{camera} = paper.view

			opoint = new paper.Point camera.point
			dpoint = new paper.Point vdata .point

			vector = dpoint.subtract opoint

			camera.translate vector

		## Storage

		# Roll back storage data
		revertStorage : ->
			do @storage.reloadMeshes