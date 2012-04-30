namespace "Maps", ->

	## Functions import
	{absoluteFrom, relativeFrom, translate, interpret} = @

	## Constants import
	{cellSize, hcellSize, qcellSize} = @

	## Materials import
	{hollow, dirt, stone} = @

	class @Location
		constructor : (@matrix) ->
			{width, height} = @

			@points =
				left  : absoluteFrom([3,         3].point())
				right : absoluteFrom([@width-4,  3].point())
				end   : absoluteFrom([@width-20, 0].point())

			# Filling @blocks
			blocks = []
			
			height.times (y) ->
				blocks[y] = []
				width.times (x) ->
					blocks[y][x] = null

			@blocks = blocks

		## Checks

		checkX : (somePoints, someSide) ->
			# Multipoints support
			args   = parseArray arguments
			
			points = args.slice 0, -1
			side   = args.last

			return points.every (point) =>
				relative = point.divide(cellSize).round()

				{x, y} = relative
				
				x += side

				return @matrix[y]?[x] is hollow

		checkY : (somePoints, someSide) ->
			# Multipoints support
			args   = parseArray arguments
			
			points = args.slice(0, -1)
			side   = args.last
			
			return points.every (point) =>
				relative = relativeFrom point

				{x, y} = relative
				
				y += side

				return @matrix[y]?[x] is hollow

		checkBorder : (point, side) ->
			relative = relativeFrom point

			{x} = relative

			return side is 'left' and x is 0 or side is 'right' and x is @width-1

		# Check if x less than @width
		checkWidth  : (x) ->
			x = x/cellSize

			return x < @width

		# Check if y less than @height
		checkHeight : (y) ->
			y = y/cellSize

			return y < @height

		## Content modifing

		# Destroy whole location
		destroy : ->
			@blocks.each (row) ->
				row.each (block) ->
					do block?.remove

		# Destroy block at point
		destroyBlockAt : (point) ->
			relative = relativeFrom point

			{x, y} = relative

			@matrix[y][x] = hollow

			do @blocks[y][x]?.remove

		# Get block id at point
		blockAt : (point) ->
			relative = relativeFrom point

			{x, y} = relative

			type = @matrix[y]?[x]

			id = translate type

			return id

		# Put block to point
		putBlock  : (point, id, shape) ->
			return unless id or shape

			type     = interpret id
			relative = relativeFrom point

			# Adding, because it is center point
			shape.position = absoluteFrom(relative).add hcellSize

			{x, y} = relative

			@blocks[y][x] = shape
			@matrix[y][x] = type

		# Spawn existing block
		spawnBlock : (point, shape) ->
			relative = relativeFrom point

			# Adding, because it is center point
			shape.position = absoluteFrom(relative).add hcellSize

			{x, y} = relative

			@blocks[y][x] = shape

		## Accessors
		@get 'height', ->
			@height_ ?= @matrix.height

		@get 'width',  ->
			@width_  ?= @matrix.width