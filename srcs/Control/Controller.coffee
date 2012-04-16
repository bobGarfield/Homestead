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

## Auxiliary function
extracter = (location) ->
	return location.matrix

namespace "Control", ->	
	
	## Import
	{State} = @
	
	class @Controller

		constructor : (@opts) ->
			{canvas, paper} = opts
			
			paper.setup   canvas
			paper.install @

		start : ->
			{interface, player, storage} = @opts

			# Autoselect location
			@location = storage.current

			# Linking interface with player inventory container
			interface.container = player.inventory.container

			do @view.resetCamera

			do @buildLocation
			do @spawnPlayer
			do @defineLoop
			do @defineMouseHandlers
			do @defineKeyboardHandlers		

		defineKeyboardHandlers : ->
			{interface, player, textures} = @opts
			
			{journal} = interface.elements

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

		defineMouseHandlers : ->
			{player} = @opts

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

		defineLoop : ->
			{player, storage} = @opts
			
			key = @Key
			
			vwidth  = @view.size.width
			vheight = @view.size.height

			# Defining onFrame handler
			@view.onFrame = =>	
				{location} = @
				{player  } = @opts
				{camera  } = @view
				
				# Checking right
				if key.isDown walkRightKey

					# Checking location
					if location.checkX(player.head, 0) and location.checkX(player.body, 0)
						player.move right

						# Checking location change
						if (side = location.checkBorder(player.body))
							if storage.follow side
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
					if location.checkX(player.head, -1) and location.checkX(player.body, -1)
						player.move left

						# Checking location change
						if (side = location.checkBorder(player.body))
							if storage.follow side
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

		spawnPlayer : ->
			{player, textures} = @opts
			{points          } = @location
			
			texture = textures.player
			point   = points.left.clone()
			
			player.shape = new @Raster texture
			
			player.spawn point

		respawnPlayerFrom: (side) ->
			{player} = @opts
			{points} = @location

			point   = points[side].clone()
			point.y = player.body.y

			player.spawn point

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

		updateLocation : ->
			{storage, player} = @opts

			do @location.destroy

			@location = storage.current

		## Work with state

		# Export state
		export : ->
			{location       } = @
			{player, storage} = @opts
			{camera         } = @view

			do storage.save

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
			{storage    } = @opts
			{maps, index} = sdata

			storage.maps.each (location, index) ->
				location.matrix = maps[index]

			storage.change index

			do @updateLocation
			do @buildLocation

			# Setting player state
			{player} = @opts
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

		## Auxiliary methods
		
		# TODO: Make more abstract
		makeBlock  : (id) ->
			{textures} = @opts

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