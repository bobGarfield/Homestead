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
walkRightKey   = 'd'
openJournalKey = 'j'
makeJumpKey    = 'space'

## Mouse buttons
leftButton  = 0
rightButton = 2

## Sides
leftSide  = -1
rightSide =  1

## Auxiliary function
extracter = (location) ->
	return location.matrix

namespace "Control", ->	
	
	## Import
	{State} = @
	
	class @Controller

		constructor : (pack) ->
			{@player, @storage, @ui, canvas, paper} = pack
			
			paper.setup canvas
			paper.install @

		## Gameplay

		# Start game
		start : ->
			{ui, player, storage} = @

			# Autoselect location
			@location = storage.currentLocation

			# Linking interface with player inventory container
			ui.container = player.inventory.container

			do @view.resetCamera

			do @buildLocation
			do @spawnPlayer
			do @defineLoop
			do @defineMouseHandlers
			do @defineKeyboardHandlers		

		# Define keyboard handlers
		defineKeyboardHandlers : ->
			{ui, player} = @
			{textures  } = @storage
			
			{journal} = ui.elements

			# Defining onKeyDown handlers
			@tool.onKeyDown = (event) =>
				# Texture handle
				if event.key is walkRightKey
					player.shape.image = textures.playerRun

				if event.key is walkLeftKey
					player.shape.image = textures.playerRunLeft

			# Defining onKeyUp handlers
			@tool.onKeyUp = (event) =>
				
				# Texture handle
				if event.key is walkRightKey
					player.shape.image = textures.player

				if event.key is walkLeftKey
					player.shape.image = textures.playerLeft

		# Define mouse handlers
		defineMouseHandlers : ->
			{player} = @

			# Defining onMouseDown handler
			@tool.onMouseDown = (event) =>
				{location} = @

				cx = @view.camera.x
				cy = @view.camera.y

				point = event.point.clone()
				
				# Adjusting for camera and whole cell
				point.x += cx - location.cellSize/4
				point.y += cy

				# Thanks to motherfucking paper.js for this
				{button} = event.event

				inventory = player.inventory

				switch button
					# Harm block (by left mouse button)
					when leftButton
						id = location.blockAt point

						inventory.put id

						location.destroyBlockAt point
					
					# Put block (by right mouse button)
					when rightButton
						
						# Checking overlap
						unless location.blockAt point
							id    = inventory.takeBlock()
							shape = @makeBlock(id)
						
							location.putBlockTo(point, id, shape)

		# Define gameloop

		# WARNING: THIS METHOD CONTAINS VIOLENCE. 21+
		# WAARSCHUWING: DEZE METHODE BEVAT GEWELD. 21+
		# ATTENZIONE: QUESTO METODO CONTIENE VIOLENZA. 21+
		# ВНИМАНИЕ: ДАННЫЙ МЕТОД СОДЕРЖИТ НАСИЛИЕ. 21+
		# ATTENTION: CETTE METHODE CONTIENT DE LA VIOLENCE. 21+
		# 警告：此方法包含的暴力行為。21+

		defineLoop : ->
			{storage} = @
			
			key = @Key
			
			vwidth  = @view.size.width
			vheight = @view.size.height

			# Defining onFrame handler
			@view.onFrame = =>	
				{location, player} = @
				{camera          } = @view
				
				# Checking right
				if key.isDown walkRightKey

					# Checking location
					if location.checkX(player.head, player.body, 0)
						player.move right

						# Checking location change
						if location.checkBorder(player.body)
							if storage.applyNeighborFrom rightSide
								do @updateLocation
								do @buildLocation

								@respawnPlayerFrom 'left'

								do @view.cancelTranslation

						# Checking camera
						if location.checkWidth(camera.x+vwidth) and player.body.x > vwidth/2	

							@view.translate toRight

				# Checking left
				if key.isDown walkLeftKey
					
					# Checking location
					if location.checkX(player.head, player.body, -1)
						player.move left

						# Checking location change
						if location.checkBorder(player.body)
							if storage.applyNeighborFrom leftSide
								do @updateLocation
								do @buildLocation

								@respawnPlayerFrom 'right'

								@view.translate location.points.end

						# Checking camera
						if camera.x > 0 and location.checkWidth(player.body.x+vwidth/2)
							@view.translate toLeft

				# Checking gravity
				if location.checkY(player.body, 1)
					player.fall down

					# Checking camera
					if location.checkHeight(camera.y+vheight) and player.body.y > vheight/2
						@view.translate toDown

					return

				# Checking jump
				if key.isDown makeJumpKey

					# Checking location
					if location.checkY(player.head, -1)
						player.jump up

						# Checking camera
						if camera.y > 0 and location.checkHeight(player.body.y+vheight/2)
							@view.translate toUp

		## Player

		# Spawn player by default
		spawnPlayer : ->
			{player  } = @
			{points  } = @location
			{textures} = @storage
			
			texture = textures.player
			point   = points.left.clone()
			
			player.shape = new @Raster texture
			
			player.spawn point

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
			{location} = @

			height = location.height
			width  = location.width

			height.times (y) =>
				width.times (x) =>
					relative = [x, y].point()
					point    = location.absoluteFrom relative

					# If there must be block
					if id = location.blockAt point
						shape = @makeBlock id

						location.spawnBlockAt point, shape

		# Update location
		updateLocation : ->
			{storage, player} = @

			do @location.destroy

			@location = storage.currentLocation

		## State

		# Export state
		export : ->
			{location, player, storage} = @
			{camera                   } = @view

			do storage.saveCurrentLocation

			pdata =
				'coord'     : player.coord
				'container' : player.inventory.container

			vdata =
				'camera'    : camera

			sdata =
				'maps'      : storage.maps.map extracter
				'index'     : location.index

			return new State
				'player'  : pdata
				'view'    : vdata
				'storage' : sdata

		# Import state
		import : (state) ->
			pdata = state.player
			vdata = state.view
			sdata = state.storage

			# Setting location state
			{storage    } = @
			{maps, index} = sdata

			storage.maps.each (location, index) ->
				location.matrix = maps[index]

			storage.changeLocation index

			do @updateLocation
			do @buildLocation

			# Setting player state
			{player} = @
			{coord } = pdata

			point = [coord.x, coord.y].point()
			player.spawn point

			# Setting inventory state
			{container} = pdata
			{inventory} = player

			inventory.container.set container

			# Setting camera
			ocamera = @view.camera
			dcamera = vdata.camera

			vector = [dcamera.x-ocamera.x, dcamera.y-ocamera.y].point()

			@view.translate vector

		## Graphics
		makeBlock  : (id) ->
			{textures} = @storage

			kind = all.rand()
			
			switch id
				when 'dirt'
					texture = textures["dirt#{kind}"]
					return new @Raster texture
				when 'stone'
					texture = textures["stone#{kind}"]
					return new @Raster texture
				else
					return null