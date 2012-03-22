## Constants
all   =  4

## Directions
left  = -5 #[px]
right =  5 #[px]
up    = 50 #[px]
down  =  5 #[px]

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
		do @drawMap
		do @spawnPlayer
		do @defineLoop
		do @defineMouseHandlers
		do @defineKeyboardHandlers

	defineKeyboardHandlers : ->
		{interface, player, textures} = @opts

		# Defining onKeyDown handlers
		@tool.onKeyDown = (event) =>
			
			# Hotkeys
			if event.key is openJournalKey
				do interface.openJournal
				do interface.drawContainer(player.inventory.container)

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
		{player, map} = @opts
		

		# Defining onMouseDown handler
		@tool.onMouseDown = (event) =>
			dist = @view.camera.x

			coord     = event.point.clone()
			coord.x  += dist

			button    = event.event.button
			inventory = player.inventory

			switch button
				
				# Destroy block (by left mouse button)
				when leftButton
					block = map.blockAt coord

					inventory.put block

					map.destroyBlockAt coord
				
				# Put block (by right mouse button)
				when rightButton
					map.putBlockTo coord, inventory.current

	defineLoop : ->
		{map, player} = @opts

		key    = @Key
		camera = @view.camera = [0, 0].point()

		# Defining onFrame handler
		@view.onFrame = =>
			
			# Checking right
			if key.isDown walkRightKey

				# Checking map
				if map.checkX(player.head, 0) and map.checkX(player.body, 0)
					player.move right

					# Checking camera
					if (camera.x+@view.size.width)/map.cellSize < map.width
						vector = [left, 0].point()

						@view.translate vector

			# Checking left
			if key.isDown walkLeftKey
				
				# Checking map
				if map.checkX(player.head, -1) and map.checkX(player.body, -1)
					player.move left

					# Checking camera
					if camera.x > 0
						vector = [right, 0].point()

						@view.translate vector

			# Checking gravity. Checking map
			if map.checkY(player.body, 1)
				player.fall down
				return

			# Checking jump
			if key.isDown makeJumpKey
				
				# Checking map
				if map.checkY(player.head, -1)
					player.jump up

	spawnPlayer : ->
		{map, player, textures} = @opts

		coord   = map.spawnPoint
		texture = textures.player

		player.spawn coord
		player.shape = new @Raster texture, coord

	drawMap : ->
		{map} = @opts

		height = map.height
		width  = map.width
		size   = map.cellSize

		(height).times (y) =>
			(width).times (x) =>
				block = map.matrix[y][x]
				rel   = [x, y].point()

				map.blocks[y][x] = @makeBlock(block, rel, size) if block

	makeBlock  : (type, rel, size) ->
		{textures} = @opts

		coord = rel.multiply(size).add(size/2)
		kind  = (all).rand()
		
		switch type
			# Land
			when 1
				texture = textures["land#{kind}"]

				return new @Raster(texture, coord)