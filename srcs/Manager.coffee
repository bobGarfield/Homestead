## Constants
all   =  4

## Directions
left  = -5 #[px]
right =  5 #[px]
up    = 50 #[px]
down  =  5 #[px]

## Vectors
toLeft  = [left,  0].point()
toRight = [right, 0].point()

## Keyboard keys
walkLeftKey    = 'a'
walkRightKey   = 'd'
openJournalKey = 'j'
makeJumpKey    = 'space'

## Mouse buttons
leftButton  = 0
rightButton = 2

class @Manager

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

			camera = @view.camera.x
			point  = event.point.clone()
			
			# Adjusting for camera and whole cell
			point.x += camera - location.cellSize/4

			# Thanks to motherfucking paper.js for this
			button    = event.event.button

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

		# Defining onFrame handler
		@view.onFrame = =>	
			{location} = @
			{camera  } = @view
			
			# Checking right
			if key.isDown walkRightKey

				# Checking location
				if location.checkX(player.head, 0) and location.checkX(player.body, 0)
					player.move right

					# Checking location change
					if (side = location.checkBorder(player.body))
						if storage.follow side
							do @rebuildLocation

							@respawnPlayerFrom 'left'

							do @view.cancelTranslation

					# Checking camera
					if (camera.x+@view.size.width)/location.cellSize < location.width
						@view.translate toRight

			# Checking left
			if key.isDown walkLeftKey
				
				# Checking location
				if location.checkX(player.head, -1) and location.checkX(player.body, -1)
					player.move left

					# Checking location change
					if (side = location.checkBorder(player.body))
						if storage.follow side
							do @rebuildLocation

							@respawnPlayerFrom 'right'

							@view.translate location.points.end

					# Checking camera
					if camera.x > 0
						@view.translate toLeft

			# Checking gravity. Checking location
			if location.checkY(player.body, 1)
				player.fall down
				return

			# Checking jump
			if key.isDown makeJumpKey
				
				# Checking location
				if location.checkY(player.head, -1)
					player.jump up

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

	rebuildLocation : ->
		{storage, player} = @opts

		do @location.destroy

		@location = storage.current

		do @buildLocation

	## Auxiliary methods
	
	# TODO: Make more abstract
	makeBlock  : (id) ->
		{textures} = @opts

		kind  = all.rand()
		
		switch id
			when 'dirt'
				texture = textures["dirt#{kind}"]
				return new @Raster texture
			when 'stone'
				texture = textures["stone#{kind}"]
				return new @Raster texture
			else
				return null